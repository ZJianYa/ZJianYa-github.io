
Specialization of @Component for classes that declare @ExceptionHandler, @InitBinder, or @ModelAttribute methods to be shared across multiple @Controller classes.

Classes with @ControllerAdvice can be declared explicitly as Spring beans or auto-detected via classpath scanning. All such beans are sorted via AnnotationAwareOrderComparator, i.e. based on @Order and Ordered, and applied in that order at runtime. For handling exceptions, an @ExceptionHandler will be picked on the first advice with a matching exception handler method. For model attributes and InitBinder initialization, @ModelAttribute and @InitBinder methods will also follow @ControllerAdvice order.

带有 @ControllerAdvice 的类会被自动的注册到 Spring 容器中。所有这样的 beans 通过 AnnotationAwareOrderComparator 排序，根据 @Order 和 Ordered，在运行时按照这个顺序生效。...

Note: For @ExceptionHandler methods, a root exception match will be preferred to just matching a cause of the current exception, among the handler methods of a particular advice bean. However, a cause match on a higher-priority advice will still be preferred to a any match (whether root or cause level) on a lower-priority advice bean. As a consequence, please declare your primary root exception mappings on a prioritized advice bean with a corresponding order!

注意：对于@ExceptionHandler方法，在特定通知bean的处理程序方法中，根目录异常匹配将优先于匹配当前异常的原因。但是，优先级较高的建议的原因匹配仍然优先于较低优先级的通知bean上的任何匹配（无论是根目录还是原因级别）。因此，请在具有相应顺序的优先级通知bean上声明主根异常映射！

By default the methods in an @ControllerAdvice apply globally to all Controllers. Use selectors annotations(), basePackageClasses(), and basePackages() (or its alias value()) to define a more narrow subset of targeted Controllers. If multiple selectors are declared, OR logic is applied, meaning selected Controllers should match at least one selector. Note that selector checks are performed at runtime and so adding many selectors may negatively impact performance and add complexity.

