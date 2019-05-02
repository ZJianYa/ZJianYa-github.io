# 事务抽象

## PlatformTransactionManager

commit  
rollback  
getTransaction  

- DataSourceTransactionManager
- HibernateTransactionManager
- JtaTransactionManager

## TransactionDefinition

- Propagation
- Isolation
- Timeout
- Read-only status

### TransactionTemplate

