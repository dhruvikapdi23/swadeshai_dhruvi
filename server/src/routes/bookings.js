const express = require('express');
const { requireUser } = require('../middleware/auth');
const bookingService = require('../services/bookingService');

const router = express.Router();

/** POST /bookings — concurrency-safe slot booking */
router.post('/', requireUser, async (req, res, next) => {
  try {
    const { venueId, slotId, date } = req.body ?? {};
    const booking = await bookingService.createBooking(req.userId, {
      venueId,
      slotId,
      date,
    });
    return res.status(201).json(booking);
  } catch (error) {
    return next(error);
  }
});

/** DELETE /bookings/:id */
router.delete('/:id', requireUser, async (req, res, next) => {
  try {
    await bookingService.cancelBooking(req.userId, req.params.id);
    return res.status(204).send();
  } catch (error) {
    return next(error);
  }
});

module.exports = router;
