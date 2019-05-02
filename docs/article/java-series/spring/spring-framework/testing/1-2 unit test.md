# 概述

https://junit.org/junit5/

## 1. Introduction to Spring Testing

## 2. Unit Testing

### 2.1. Mock Objects

#### 2.1.1. Environment

org.springframework.mock.env

#### 2.1.2. JNDI

#### 2.1.3. Servlet API

org.springframework.mock.web

#### 2.1.4. Spring Web Reactive

## 2.2. Unit Testing support Classes

### 2.2.1. General testing utilities

org.springframework.test.util

EasyMock or Mockito , JUnit, TestNG

### 2.2.2. Spring MVC

The org.springframework.test.web package contains ModelAndViewAssert, which you can use in combination with JUnit, TestNG, or any other testing framework for unit tests dealing with Spring MVC ModelAndView objects.

>Unit testing Spring MVC Controllers
To unit test your Spring MVC Controllers as POJOs, use ModelAndViewAssert combined with MockHttpServletRequest, MockHttpSession, and so on from Spring’s Servlet API mocks. For thorough integration testing of your Spring MVC and REST Controllers in conjunction with your WebApplicationContext configuration for Spring MVC, use the Spring MVC Test Framework instead.

## 3. Integration Testing

## FAQ

- Assertions.assertThrows 中的message是干啥的
