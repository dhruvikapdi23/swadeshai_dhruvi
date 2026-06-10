const express = require('express');
const { requireUser } = require('../middleware/auth');
const bookingService = require('../services/bookingService');

const router = express.Router();

/** GET /users/:id/bookings */
router.get('/:id/bookings', requireUser, async (req, res, next) => {
  try {
    if (req.params.id !== req.userId) {
      return res.status(403).json({ error: 'Cannot view another user\'s bookings' });
    }

    const bookings = await bookingService.getUserBookings(req.userId);
    return res.json(bookings);
  } catch (error) {
    return next(error);
  }
});

module.exports = router;
