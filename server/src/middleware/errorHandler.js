const { SlotTakenError } = require('../services/bookingService');

function errorHandler(err, _req, res, _next) {
  if (err instanceof SlotTakenError || err.status === 409) {
    return res.status(409).json({ error: err.message });
  }

  if (err.status) {
    return res.status(err.status).json({ error: err.message });
  }

  console.error(err);
  return res.status(500).json({ error: 'Internal server error' });
}

module.exports = { errorHandler };
