# database_weekendChallenge

## Challenge Description: 

# You are working on a database for a library management system. Your task is to write SQL queries, create triggers, CTEs, user-defined functions, and views to implement various functionalities within the system.

Schema Details: Consider the following simplified schema for the library management system:

Books (BookID, Title, Author, PublicationYear, Status)
Members (MemberID, Name, Address, ContactNumber)
Loans (LoanID, BookID, MemberID, LoanDate, ReturnDate)

Challenge Tasks:

# 1. Write a trigger that automatically updates the "Status" column in the "Books" table whenever a book is loaned or returned. The "Status" should be set to 'Loaned' if the book is loaned and 'Available' if the book is returned.

# 2. Create a CTE that retrieves the names of all members who have borrowed at least three books.
------------------------------------------------------------------------------------------------

# 3. Write a user-defined function that calculates the overdue days for a given loan. The function should accept the LoanID as a parameter and return the number of days the loan is overdue.
--------------------------------------------------------------------------------------------------
# 4. Create a view that displays the details of all overdue loans, including the book title, member name, and number of overdue days.
---------------------------------------------------------------------------------------------------

# 5. Write a trigger that prevents a member from borrowing more than three books at a time. If a member tries to borrow a book when they already have three books on loan, the trigger should raise an error and cancel the operation.
