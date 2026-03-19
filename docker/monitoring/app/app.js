const express = require('express')
const client = require('prom-client')

const app = express()
const PORT = process.env.PORT || 3000

// Enable default metrics (process CPU, memory, event loop lag, etc.)
const register = new client.Registry()
client.collectDefaultMetrics({ register })

// Custom counter: total HTTP requests by method and route
const httpRequestsTotal = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
  registers: [register],
})

// Custom histogram: request duration
const httpRequestDurationSeconds = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route'],
  buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5],
  registers: [register],
})

// Custom gauge: active connections
const activeConnections = new client.Gauge({
  name: 'active_connections',
  help: 'Number of active connections',
  registers: [register],
})

// Middleware to record request metrics
app.use((req, res, next) => {
  const end = httpRequestDurationSeconds.startTimer({ method: req.method, route: req.path })
  activeConnections.inc()
  res.on('finish', () => {
    httpRequestsTotal.labels(req.method, req.path, res.statusCode).inc()
    end()
    activeConnections.dec()
  })
  next()
})

// Metrics endpoint — Prometheus scrapes this
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType)
  res.end(await register.metrics())
})

app.get('/', (req, res) => {
  res.json({ message: 'Monitored app', version: '1.0.0' })
})

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', uptime: process.uptime() })
})

// Slow endpoint for histogram exercise data — simulates 100-500ms random latency
app.get('/slow', (req, res) => {
  const delay = Math.floor(Math.random() * 400) + 100
  setTimeout(() => {
    res.json({ message: 'slow response', delay_ms: delay })
  }, delay)
})

// Alert webhook — Alertmanager sends alerts here for webhook exercise
app.post('/alert-webhook', express.json(), (req, res) => {
  console.log('[ALERT WEBHOOK]', JSON.stringify(req.body, null, 2))
  res.json({ status: 'received' })
})

app.listen(PORT, () => console.log(`Server on port ${PORT}, metrics at /metrics`))
