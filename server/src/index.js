require('dotenv').config();

const cors = require('cors');
const express = require('express');
const { initFirebase } = require('./config/firebase');
const { errorHandler } = require('./middleware/errorHandler');
const { seedVenuesIfEmpty } = require('./services/seedService');
const authRouter = require('./routes/auth');
const venuesRouter = require('./routes/venues');
const bookingsRouter = require('./routes/bookings');
const usersRouter = require('./routes/users');

const PORT = Number(process.env.PORT) || 3000;

async function start() {
  initFirebase();
  await seedVenuesIfEmpty();

  const app = express();

  app.use(cors());
  app.use(express.json());

  app.get('/health', (_req, res) => {
    res.json({ status: 'ok', service: 'quickslot-api' });
  });

  app.use('/auth', authRouter);
  app.use('/venues', venuesRouter);
  app.use('/bookings', bookingsRouter);
  app.use('/users', usersRouter);

  app.use(errorHandler);

  app.listen(PORT, '0.0.0.0',() => {
    console.log(`QuickSlot API running on http://localhost:${PORT}`);
  });
}

start().catch((error) => {
  console.error('Failed to start server:', error.message);
  process.exit(1);
});
