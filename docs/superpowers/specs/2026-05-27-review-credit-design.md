# Review And Credit Design

## Goal

Complete the course-project "评价与信用" module described in `docs/分工文档/评价与信用.docx` with a small, demonstrable implementation.

## Scope

- Users can review a completed order with a 1-5 score and optional text.
- Each user can review the same order once.
- A received review updates the reviewed user's credit score.
- User profile and product detail responses expose seller/user credit score and review count.
- Clients can query received reviews for a user.
- Android screens can submit reviews and display basic credit/review information.

## Backend Design

The existing order review flow remains the write path. `OrderService.review` creates the review, recalculates the reviewed user's score, and sends a notification.

Add read support in the same business area:

- `ReviewRepository` exposes paged lookup by `revieweeId` and count by `revieweeId`.
- `OrderService` exposes `getReviewsForUser(userId, page, size)`.
- `UserProfileResponse` and `ProductResponse` gain `reviewCount` and seller credit fields where useful.
- `UserService` and `ProductService` fill the new fields from `ReviewRepository`.
- `OrderController` exposes `GET /api/orders/reviews/user/{userId}`.

Credit score stays as the current integer scale: average star score multiplied by 20, so 5 stars becomes 100 and 4 stars becomes 80.

## Android Design

Use the existing Retrofit and ViewModel patterns:

- Extend DTOs with `reviewCount`, seller credit fields, and `ReviewDto`.
- Add API calls for `POST /api/orders/{id}/review` and `GET /api/orders/reviews/user/{userId}` if missing.
- Add review submit state to order UI.
- Show credit score and review count in product detail and profile screens.

## Testing

- Fix existing backend integration test registration helper to include `studentId`.
- Add backend integration coverage for review count and credit score after review.
- Run backend tests with `mvn test`.
- Android compile/test may require a valid Android SDK configured in `local.properties` or `ANDROID_HOME`.
