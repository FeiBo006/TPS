# Review And Credit Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete the course-project review and credit module with backend review queries, credit metadata, Android display, and submission support.

**Architecture:** Keep review writes in `OrderService.review`, add read APIs around the existing `Review` entity, and surface aggregate review metadata through existing user/product DTOs. Android follows the current Retrofit/ViewModel/screen structure and avoids new frameworks.

**Tech Stack:** Spring Boot 3, Spring Data JPA, MockMvc integration tests, Kotlin Android Compose, Retrofit.

---

### Task 1: Backend Review Metadata

**Files:**
- Modify: `backend/src/test/java/com/tps/BackendIntegrationTest.java`
- Modify: `backend/src/main/java/com/tps/repository/ReviewRepository.java`
- Modify: `backend/src/main/java/com/tps/dto/user/UserProfileResponse.java`
- Modify: `backend/src/main/java/com/tps/dto/product/ProductResponse.java`
- Modify: `backend/src/main/java/com/tps/service/UserService.java`
- Modify: `backend/src/main/java/com/tps/service/ProductService.java`

- [ ] Fix the registration helper to include a generated numeric `studentId`.
- [ ] Add failing assertions that a reviewed seller profile has `creditScore=100` and `reviewCount=1`.
- [ ] Add repository count support and fill `reviewCount`.
- [ ] Run `mvn test` from `backend`.

### Task 2: Backend Review List API

**Files:**
- Modify: `backend/src/test/java/com/tps/BackendIntegrationTest.java`
- Modify: `backend/src/main/java/com/tps/repository/ReviewRepository.java`
- Modify: `backend/src/main/java/com/tps/service/OrderService.java`
- Modify: `backend/src/main/java/com/tps/controller/OrderController.java`

- [ ] Add failing test for `GET /api/orders/reviews/user/{sellerId}` returning the submitted review.
- [ ] Add paged repository method `findByRevieweeIdOrderByCreatedAtDesc`.
- [ ] Add service/controller read endpoint.
- [ ] Run `mvn test` from `backend`.

### Task 3: Android DTO And API Wiring

**Files:**
- Modify: `app/src/main/java/com/tps/data/remote/dto/Dtos.kt`
- Modify: `app/src/main/java/com/tps/data/remote/api/ApiService.kt`

- [ ] Add `reviewCount`, seller credit fields, and `ReviewDto`.
- [ ] Add Retrofit methods for submitting and listing reviews.
- [ ] Run Android compilation if SDK is available.

### Task 4: Android UI Integration

**Files:**
- Modify: `app/src/main/java/com/tps/ui/order/OrderViewModel.kt`
- Modify: `app/src/main/java/com/tps/ui/order/MyOrdersScreen.kt`
- Modify: `app/src/main/java/com/tps/ui/product/ProductDetailScreen.kt`
- Modify: `app/src/main/java/com/tps/ui/profile/MyProfileScreen.kt`

- [ ] Add review submission state and action.
- [ ] Show a simple review form for completed orders.
- [ ] Show credit score and review count in product detail/profile.
- [ ] Run Android compilation if SDK is available.

## Self Review

- Covers both docx use cases: review transaction and view credit score.
- No new authentication or payment complexity.
- Uses existing entities and UI patterns.
- Android verification depends on local SDK availability.
