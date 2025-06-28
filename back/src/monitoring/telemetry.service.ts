import { Injectable } from '@nestjs/common';
import { NodeSDK } from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { Resource } from '@opentelemetry/resources';
import { SemanticResourceAttributes } from '@opentelemetry/semantic-conventions';
import { JaegerExporter } from '@opentelemetry/exporter-jaeger';
import { PrometheusExporter } from '@opentelemetry/exporter-prometheus';

@Injectable()
export class TelemetryService {
  private sdk: NodeSDK;
  private prometheusExporter: PrometheusExporter;

  constructor() {
    this.initializeTelemetry();
  }

  private initializeTelemetry() {
    // Configuration des exporteurs
    const jaegerExporter = new JaegerExporter({
      endpoint: process.env.JAEGER_ENDPOINT || 'http://localhost:14268/api/traces',
    });

    this.prometheusExporter = new PrometheusExporter({
      port: 9464, // Port pour les métriques Prometheus
    });

    // Configuration du SDK OpenTelemetry
    this.sdk = new NodeSDK({
      resource: new Resource({
        [SemanticResourceAttributes.SERVICE_NAME]: 'p10-backend',
        [SemanticResourceAttributes.SERVICE_VERSION]: '1.0.0',
        [SemanticResourceAttributes.DEPLOYMENT_ENVIRONMENT]: process.env.NODE_ENV || 'development',
      }),
      traceExporter: jaegerExporter,
      metricReader: this.prometheusExporter,
      instrumentations: [
        getNodeAutoInstrumentations({
          // Désactiver certaines instrumentations si nécessaire
          '@opentelemetry/instrumentation-fs': {
            enabled: false,
          },
          '@opentelemetry/instrumentation-http': {
            enabled: true,
            requestHook: (span, request) => {
              if ('headers' in request) {
                span.setAttributes({
                  'http.request.header.user-agent': request.headers['user-agent'] || '',
                  'http.request.header.content-type': request.headers['content-type'] || '',
                });
              }
            },
            responseHook: (span, response) => {
              if ('headers' in response) {
                span.setAttributes({
                  'http.response.header.content-type': response.headers['content-type'] || '',
                });
              }
            },
          },
          '@opentelemetry/instrumentation-express': {
            enabled: true,
          },
          '@opentelemetry/instrumentation-graphql': {
            enabled: true,
          },
        }),
      ],
    });
  }

  start() {
    try {
      this.sdk.start();
      console.log('OpenTelemetry started successfully');
    } catch (error) {
      console.error('Error starting OpenTelemetry:', error);
    }
  }

  async shutdown() {
    try {
      await this.sdk.shutdown();
      console.log('OpenTelemetry shut down successfully');
    } catch (error) {
      console.error('Error shutting down OpenTelemetry:', error);
    }
  }

  // Méthode pour obtenir les métriques Prometheus
  getPrometheusMetrics(): string {
    // Cette méthode sera utilisée si nécessaire, pour l'instant on retourne une chaîne vide
    return '';
  }
}
