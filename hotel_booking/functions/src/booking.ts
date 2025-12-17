import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();
const db = admin.firestore();

// Atomic Booking Creation
export const createBooking = functions.https.onCall(async (data, context) => {
  // 1. Validate Authentication
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'The function must be called while authenticated.'
    );
  }

  const { hotelId, roomId, checkIn, checkOut, guestCount, totalPrice } = data;
  const userId = context.auth.uid;

  // 2. Validate Input Data
  if (!hotelId || !roomId || !checkIn || !checkOut || !guestCount || !totalPrice) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing required booking details.'
    );
  }

  const checkInDate = new Date(checkIn);
  const checkOutDate = new Date(checkOut);

  if (checkInDate >= checkOutDate) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Check-in date must be before check-out date.'
    );
  }

  // 3. Run Transaction
  return db.runTransaction(async (transaction) => {
    // Check for overlapping bookings
    const bookingsRef = db.collection('bookings');
    const snapshot = await transaction.get(
      bookingsRef
        .where('roomId', '==', roomId)
        .where('status', '==', 'confirmed')
    );

    const hasOverlap = snapshot.docs.some((doc) => {
      const existingCheckIn = doc.data().checkIn.toDate();
      const existingCheckOut = doc.data().checkOut.toDate();
      return (
        (checkInDate < existingCheckOut) && (checkOutDate > existingCheckIn)
      );
    });

    if (hasOverlap) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'Room is not available for the selected dates.'
      );
    }

    // Create Booking
    const bookingRef = bookingsRef.doc();
    const bookingData = {
      userId,
      hotelId,
      roomId,
      checkIn: admin.firestore.Timestamp.fromDate(checkInDate),
      checkOut: admin.firestore.Timestamp.fromDate(checkOutDate),
      guestCount,
      totalPrice,
      status: 'confirmed',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    transaction.set(bookingRef, bookingData);

    return { bookingId: bookingRef.id };
  });
});

// Cancel Booking
export const cancelBooking = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'The function must be called while authenticated.'
    );
  }

  const { bookingId } = data;
  const userId = context.auth.uid;

  const bookingRef = db.collection('bookings').doc(bookingId);
  const bookingDoc = await bookingRef.get();

  if (!bookingDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Booking not found.');
  }

  const bookingData = bookingDoc.data();
  if (bookingData?.userId !== userId) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'You can only cancel your own bookings.'
    );
  }

  await bookingRef.update({ status: 'cancelled' });

  return { success: true };
});
