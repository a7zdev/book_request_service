# Book Request Service

A rails API service for library book request management

## Setup

Note: The ruby version for this project is `2.5.5`

In your terminal cd to the project directory and run:
```bash
bin/setup
```
To start the project:
```bash
rails server
```
By default it will run on port 3000

## Running test suite
```bash
bundle exec rspec
```

## Key API Actions

> POST /request

This action creates a new request for a book.

**Params**

| Field | Description |
| :---------: | :----: |
| email | The email of the requesting user |
| title | The title of the book being requested |

**Sample Payload:**

```json
{
  "email": "john.doe@example.com", # Email of the requesting user
  "title": "The Giver" # Note: Title is case sensitive
}
```
**Response examples:**
```json
# The book is available and a request has been
# created for the requesting user

# 200 HTTP status

{
  "id": "14", # The book id
  "available": true,
  "title": "The Giver",
  "timestamp": "2020-12-02T17:32:05Z" # Time the request was created
}

# Note: If the timestamp is farther in the past than expected, it indicates that
# the request already existed.
```
```json
# The book is not available and a request has not been
# created for the requesting user

# 200 HTTP status

{
  "id": "14",
  "available": false,
  "title": "The Giver",
  "timestamp": "2020-12-02T17:32:05Z" # Time the existing request was created
}
```
```json
# The library does not carry the requested book

# 404 HTTP status

{
  "error": "book-not-found"
}
```
```json
# The provided email is not a properly formatted email

# 422 HTTP status

{
  "error": "invalid-email"
}
```
------------------------------

> GET /request/:id

This action retrieves a single book request

**Params**

| Field | Description |
| :---------: | :----: |
| id | The id of the requested book |

**Response Examples:**
```json
# Success
# 200 HTTP Status

{
  "id": "14",
  "available": false,
  "title": "The Cat in the Hat",
  "timestamp": "2020-12-02T17:30:00Z"
}
```
```json
# No matching request found
# 404 HTTP Status

{
  "error": "request-not_found"
}
```
------------------------------

> DELETE /request/:id

This action deletes a book request making it available again

**Params**

| Field | Description |
| :---------: | :----: |
| id | The id of the requested book |

**Response Examples:**
```json
# Success
# 200 HTTP Status
# Empty json body
{}
```
```json
# No matching request found
# 404 HTTP Status

{
  "error": "request-not_found"
}
```
------------------------------

> GET /request

This action retrieves all existing book requests

**Response Examples:**
```json
# Success
# 200 HTTP Status

[
  {
    "id": "14",
    "available": false,
    "title": "The Cat in the Hat",
    "timestamp": "2020-12-02T17:30:00Z"
  },
  {
    "id": "27",
    "available": false,
    "title": "Rich Dad, Poor Dad",
    "timestamp": "2020-11-21T10:30:00Z"
  },
]
```
------------------------------

> GET /books

This action retrieves all books that the library carries

**Response Examples:**
```json
# Success
# 200 HTTP Status

[
  {
    "id": "14",
    "title": "The Cat in the Hat",
  },
  {
    "id": "27",
    "title": "Rich Dad, Poor Dad",
  },
]
```

## Data model (resource attributes)
### **books**
| Attribute | Type |
| :---------: | :----: |
| id | integer |
| title | string |
| created_at | datetime |
| updated_at | datetime |
------

### **requests**
| Attribute | Type |
| :---------: | :----: |
| id | integer |
| email | string |
| book_id | integer |
| created_at | datetime |
| updated_at | datetime |
------

## Future Improvements

- [ ] Additional specs
- [ ] Additional clarification on implementation details/specs
- [ ] Rubofixes