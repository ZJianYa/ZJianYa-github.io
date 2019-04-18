https://docs.spring.io/spring-security/site/docs/4.2.4.RELEASE/guides/html5/helloworld-xml.html  



## Setting up the sample
This section outlines how to setup a workspace within Spring Tool Suite (STS) so that you can follow along with this guide. The next section outlines generic steps for how to apply Spring Security to your existing application. While you could simply apply the steps to your existing application, we encourage you to follow along with this guide in order to reduce the complexity.

本节概述如何在Spring Tool Suite（STS）中设置工作区，以便您可以按照本指南进行操作。 下一节概述了如何将Spring Security应用到现有应用程序的一般步骤。 虽然您可以简单地将这些步骤应用于现有的应用程序，但我们鼓励您遵循本指南以降低复杂性。
### Obtaining the sample project

### Import the insecure sample application  


### Running the insecure application  

## Securing the application  
Before securing your application, it is important to ensure that the existing application works as we did in Running the insecure application. Now that the application runs without security, we are ready to add security to our application. This section demonstrates the minimal steps to add Spring Security to our application.  

### Updating your dependencies

Spring Security GA releases are included within Maven Central, so no additional Maven repositories are necessary.

In order to use Spring Security you must add the necessary dependencies. For the sample we will add the following Spring Security dependencies:

*pom.xml*  
```
...
```

After you have completed this, you need to ensure that STS knows about the updated dependencies by:

Right click on the spring-security-samples-xml-insecure application

Select Maven→Update project…​

Ensure the project is selected, and click OK

### Creating your Spring Security configuration
The next step is to create a Spring Security configuration.

In the Package Explorer view, right click on the folder src/main/webapp

Select New→Folder

Enter WEB-INF/spring for the Folder name

Then right click on the new folder WEB-INF/spring

Select New→File

Enter security.xml for the File name

Click Finish

Replace the contents of the file with the following:

src/main/webapp/WEB-INF/spring/security.xml
```
<b:beans xmlns="http://www.springframework.org/schema/security"
		 xmlns:b="http://www.springframework.org/schema/beans"
		 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		 xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
						http://www.springframework.org/schema/security http://www.springframework.org/schema/security/spring-security.xsd">

	<http />

	<user-service>
		<user name="user" password="password" authorities="ROLE_USER" />
	</user-service>

</b:beans>
```
...  



### Registering Spring Security with the war  

