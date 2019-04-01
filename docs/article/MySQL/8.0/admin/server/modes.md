
https://dev.mysql.com/doc/refman/8.0/en/sql-mode.html

server 可以在不同的modes下操作，可以为不同的client应用不同的modes，依赖于system variable中的sql_mode的值。DBAs可以设置全局的mode来匹配site server操作的需要，每个应用也可以设置自己会话的Mode。

Modes影响SQL语法的支持，数据验证影响其性能。这方便了在不同环境中使用mysql，和与其他数据库一起使用MySQL。

- Setting the SQL Mode  

- The Most Important SQL Modes  
最重要的SQL Modes

- Full List of SQL Modes  

- Combination SQL Modes  
SQL Modes组合

- Strict SQL Mode  
严格SQL模式

- Comparison of the IGNORE Keyword and Strict SQL Mode  

- SQL Mode Changes in MySQL 5.7  

更多关于modes的FAQ，查看[ Section A.3, “MySQL 8.0 FAQ: Server SQL Mode”](https://dev.mysql.com/doc/refman/8.0/en/faqs-sql-modes.html)

使用InnoDB表的时候，考虑使用innodb_strict_mode，会为InnoDB表启用额外的错误检查。

**Setting the SQL Mode**

**The Most Important SQL Modes**

The most important sql_mode values are probably these:

- ANSI

    This mode changes syntax and behavior to conform more closely to standard SQL. It is one of the special combination modes listed at the end of this section.  
这个模式修改了语法和行为，以便更加符合标准SQL。是本节最后列出的特殊组合之一。
- STRICT_TRANS_TABLES

    If a value could not be inserted as given into a transactional table, abort the statement. For a nontransactional table, abort the statement if the value occurs in a single-row statement or the first row of a multiple-row statement. More details are given later in this section.  
如果某个值无法插入事务表中，则终止该语句。对于非事务性的表，如果这个值发生在单行语句或者多行语句的第一行，则终止该语句。  
    As of MySQL 5.7.5, the default SQL mode includes STRICT_TRANS_TABLES.  
 从MySQL 5.7.5开始，默认的SQL模式包括STRICT_TRANS_TABLES。  
- TRADITIONAL

    Make MySQL behave like a “traditional” SQL database system. A simple description of this mode is “give an error instead of a warning” when inserting an incorrect value into a column. It is one of the special combination modes listed at the end of this section.   
使MySQL像“传统”的SQL数据库系统一样行事。 在将不正确的值插入列时，此模式的简单描述是“给出错误而不是警告”。 这是本节最后列出的特殊组合模式之一。  

**Strict SQL Mode  **
严格模式控制MySQL在data-change语句中如何处理无效值。一个value不合法的原因可能有如下几个。例如：  
1. 类型错误  
2. 超出范围
3. 非空列，没有默认值，但是插入的却是NULL值
也会影响DDL语句  

如果严格模式没有生效，Mysql在发生上述问题的时候，会产生警告。在严格模式中，你可以使用INSERT IGNORE或UPDATE IGNORE来produce this behavior  

对于不改变数据的SELECT等语句，无效值将在严格模式下生成警告，而不是错误。  

对于尝试创建超出最大密钥长度的密钥的严格模式，会产生错误。严格模式未启用时，会导致警告并将密钥截断为最大密钥长度。

... 

如果启用了STRICT_ALL_TABLES或STRICT_TRANS_TABLES，则严格的SQL模式有效，但这些模式的效果有所不同：