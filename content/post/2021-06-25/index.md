---
title: Teststubs with Kotlin Extensions
description: Utilizing Kotlin Extensions to create stubs for testing.
slug: 2021-teststubs-with-kotlin-extensions
date: 2021-06-25 22:00:00+0000
categories:
    - Software Engineering
tags:
    - Software Engineering
    - Kotlin
weight: 1
---

The repository with the Kotlin code can be found on [github/MisterDerpie/kotlin-data-stubs](https://github.com/MisterDerpie/kotlin-data-stubs).

Currently I'm having the great luck that our team started using Kotlin at work.
For that reason, I decided to learn Kotlin properly and started my journey with [Kotlin in Action](https://www.manning.com/books/kotlin-in-action) (2017, Manning).
This is a bit outdated, considering that Kotlin 1.5 is the current release, but the vast majority of concepts are the same as for 1.0.

One concept that fascinates me and I really see a lot of value in is [Extensions](https://kotlinlang.org/docs/extensions.html).
Especially for tests I find that concept very useful, because it enables us to provide test related logic to our classes without actually adding this in the real production code.
Let's have a look at how we can utilize extensions to create stubs of business classes.

# Problem statement in Java

## Test Utils to Stub Classes

A problem that often arises in Java projects is that you need to provide stubs for using e.g. the same customer in multiple tests.
Suppose you have a class `Customer.java` that looks like this

```java
@AllArgsConstructor /* Generates constructor with all parameters */
@Getter /* Generates getters for all properties */ 
public class Customer {
    
    private final UUID id;
    private final String name;
    private final Integer age;

}
```

and you would like to stub the same customer for your tests.
How would you do that?
Probably you create some class called `TestUtils.java`, that provides a static method `stubCustomer`.
In larger projects, you most likely have many different stubs in it, from Address over Customer to Shopping Cart.
Thus, you start adding all these stubs in the `TestUtils` class.

```java
public class TestUtils {

    public static Customer stubCustomer() {
        ...
    }

    public static Address stubAddress() {
        ...
    }

    ...
}
```

I have seen such classes having hundreds of lines of code, with many different, totally unrelated objects.
A first attempt to improve that would be to create `TestUtilsCustomer.java`, `TestUtilsAddress.java`, ...
That would leave us with a better, yet still not the best solution.

## Test Code meets Production Code

Wouldn't it be nice to provide `stubCustomer` directly in the `Customer` itself?
With Java, you would have to include such method in your production code.

```java
@AllArgsConstructor /* Generates constructor with all parameters */
@Getter /* Generates getters for all properties */ 
public class Customer {
    
    private final UUID id;
    private final String name;
    private final Integer age;

    public static Customer stubFullAgeCustomer() {
        return new Customer(UUID.randomUUID(), "JavaName", 18)
    }

}
```

Testcode should never, **never** reside in production code.
With Kotlin, we can actually do that, but without production code ever knowing about this `stubFullAgeCustomer` method.

# Solution in Kotlin

Before continue reading, think about why it would be nice to have a preconfigured Customer provided by the `Customer` object itself.
When implementing the [Builder Pattern](https://en.wikipedia.org/wiki/Builder_pattern), you configure each property by a callchain of functions with the properties' names.
It could look like this `Customer.name("Builder").age(23).uuid(UUID.randomUUID()).build()`.
So why not getting a fully preset instance as part of this object, too?

This can be achieved in Kotlin.

## Setup

We define a `Customer` data class and an `AgeCheckService` (the latter is purely to have something to test, so that I can show how our extension works).

`Customer.kt`
```kotlin
package dto

import java.util.UUID

data class Customer(
    val id: UUID,
    val name: String,
    val age: Int) {
    companion object {}
}
```

What enables us to extend the `Customer` with new "static" methods for our test is the [companion object](https://kotlinlang.org/docs/object-declarations.html#companion-objects).
As this is a pure data class, we don't add anything else.

`AgeCheckService.kt`
```kotlin
package service

import dto.Customer

class AgeCheckService {
    companion object {
        fun isCustomerOfFullAge(customer: Customer): Boolean {
            return customer.age >= 18
        }
    }
}
```

This services only functionality is to return `true` when the customer is of full age, and `false` when they're minor.
As initially stated, this is for the sole purpose of having something to test.

## Extend Customer

In our test, we would like to call the following:

```kotlin
Customer.stubFullAgeCustomer()
Customer.stubMinorAgeCustomer()
```

to retrieve preconfigured customers with _some_ age greater or equal than 18 or less than 18, respectively.
This is as easy as doing [companion object extensions](https://kotlinlang.org/docs/extensions.html#companion-object-extensions).

To do so, simply place a file in your testpath, and define the functions on `Customer.Companion`.

```kotlin
package dto

import java.util.UUID

fun Customer.Companion.stubFullAgeCustomer(): Customer {
    return Customer(UUID.nameUUIDFromBytes("This is some string for UUID".toByteArray()), "MisterDerpie", 24)
}

fun Customer.Companion.stubMinorAgeCustomer(): Customer {
    return Customer(UUID.nameUUIDFromBytes("This is another UUID string".toByteArray()), "MinorPerson", 17)
}
```

Note that when you do not define a name for the companion object in the class, it will be accessible by `Companion`.
Congratulations, you just added extensions which you can use in your tests.

## Test AgeCheckService using Extension Stub

The last step is to import your Extensions into your test.
They are not automatically applied globally to your Customer, which is the reason why you explicitly have to import them.

```kotlin
package service

import dto.Customer
import dto.stubFullAgeCustomer
import dto.stubMinorAgeCustomer
import org.junit.jupiter.api.Test
import org.assertj.core.api.Assertions.assertThat

class AgeCheckServiceTest {

    @Test
    fun `should return true when customer is of full age`() {
        val customer = Customer.stubFullAgeCustomer()
        assertThat(AgeCheckService.isCustomerOfFullAge(customer)).isEqualTo(true)
    }

    @Test
    fun `should return false when customer is of minor age`() {
        val customer = Customer.stubMinorAgeCustomer()
        assertThat(AgeCheckService.isCustomerOfFullAge(customer)).isEqualTo(false)
    }

}
```

See the imports at the top.
I placed the `Customer` in a package called `dto`.
The `stubFullAgeCustomer` and `stubMinorAgeCustomer` are also placed in a package called `dto` (but the name doesn't matter, it's just due to the same folder structure in the tests).
As stated initially, we need to import them to actually apply the extension to the `Customer`.

The tests are then straightforward: Get the customer and assert that the age service in fact returns `true` when they're of full age and `false` when they're of minor age.