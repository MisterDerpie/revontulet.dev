---
title: Don't Let Your Mocks Mock You!
description: >
    Mock testing is useful, but there is a risk of building false confidence when we don't pay close attention.
slug: 2025-dont-let-your-mocks-mock-you
date: 2025-09-12 10:00:00+0000
categories:
    - Software-Engineering
tags:
    - Software Engineering
    - Golang
keywords:
    - Software Engineering
    - Golang
    - Go
    - Mocking
    - Testing
weight: 1
---

Here's a short one about a pattern that we can unfortunately too often observe when it comes to mocks.
Especially with databases, we see our "Repository" or "Database Connection" mocked out in tests.
That is, for the sake of unhappy path testing.
However, more often than not we also see that these mocks are used for happy path testing.

There is a real danger where our _mocks are mocking_ us.

## The Bad

Let's look at some very simple code.
We have a service that gets a request and ends up inserting data into a DB, via some repository.
Potentially, the code is close to this:

```go
// service.go
func (s *Service) InsertIntoDb(request Request) (Response, error) {
    dbQuery, err := buildInsertQuery(request)
    // if err ! nil ...

    // The actual insert
    result, err := s.repository.
        ExecuteQuery(
            dbQuery.TableName,
            dbQuery.Query,
        );
    // if err != nil ...

    return result, nil
}
```

```go
// repository.go
func (r *Repository) ExecuteQuery(
    query string, 
    tableName string
) (Response, error) {
    // For the sake of the argument
    // We take 2 strings as input
    // ... don't do that at home!
}
```

The mistake may be obvious to you now as a reader, as the code is very small and colocated.
In reality, it is hard to spot that the first parameter is expected to be the query string, and the second parameter to be the table name.
Especially, if the reviewer of this code does not look at the signature of ExecuteQuery (and ask yourself, how often do you open a library and check that the call you see in a PR is correct?).

## The Ugly

Consider a test like below.

```go
func Test_InsertIntoDb(t *testing.T) {
    mockRepo := new(MockRepository)
    service := &Service{repository: mockRepo}

    req := Request{TableName: "users", Data: "foo"}
    expectedResp := Response{OK: true}

    mockRepo.
        On("ExecuteQuery", "users", "INSERT {...}").
        Return(expectedResp, nil).
        Once()

    resp, err := service.InsertIntoDb(req)
    // NoError, Resp is OK
    mockRepo.AssertExpectations(t)
}
```

While the test looks right on the surface, are we actually testing that our insert works?
Nope.
At best, we verify that _some string_ was passed as the first parameter, and _some other string_ was passed as the second one,
supposedly the table name and the insert query respectively.
But looking at the method's signature, the order would be to first pass the query and then pass the table name.



[Oh no, anyway!](https://knowyourmeme.com/memes/oh-no-anyway), with this test (and all other mock tests), we hit 100% Code Coverage!
Great, our system is fully tested, straight to production!

![](mfw-pikachu.webp)

## The Good

If we want to verify our happy path with _integrated_ technologies, we can oftentimes use the real deal in _integration_ tests (and if we can't, we should really work towards being able to).
Pretty much any major technology, from cloud provider over databases to message brokers, is offered as a [testcontainer](https://testcontainers.com/).
Using Testcontainers for Integration Tests, or connecting to a real instance and creating ephemeral data, can greatly increase our confidence in the unit under test.

On a side note: With Cursor or Claude Code, we're seeing a lot of seemingly correct mock tests.
AI code generators love Mocks, and they often enough end up creating tests that claim to test something way beyond capability.
Be sure to pay extra attention there.
