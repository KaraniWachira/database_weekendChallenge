CREATE SCHEMA LibraryManagement;

GO

CREATE TABLE Books
(
  BookID INT NOT NULL
    CONSTRAINT PK_Books
    PRIMARY KEY CLUSTERED,
  Title VARCHAR(255) NOT NULL,
  Author VARCHAR(255) NOT NULL,
  PublicationYear YEAR NOT NULL,
  Status VARCHAR(255) NOT NULL
);

GO

CREATE TABLE Members
(
  MemberID INT NOT NULL
    CONSTRAINT PK_Members
    PRIMARY KEY CLUSTERED,
  Name VARCHAR(255) NOT NULL,
  Address VARCHAR(255) NOT NULL,
  ContactNumber VARCHAR(255) NOT NULL
);

GO

CREATE TABLE Loans
(
  LoanID INT NOT NULL
    CONSTRAINT PK_Loans
    PRIMARY KEY CLUSTERED,
  BookID INT NOT NULL
    CONSTRAINT FK_Loans_BookID
    FOREIGN KEY REFERENCES Books (BookID),
  MemberID INT NOT NULL
    CONSTRAINT FK_Loans_MemberID
    FOREIGN KEY REFERENCES Members (MemberID),
  LoanDate DATE NOT NULL,
  ReturnDate DATE NULL
);

GO

-- get all books
SELECT * 
FROM Books;

-- get all members
SELECT *
FROM Members;

-- get all loans
SELECT * 
FROM Loans;

-- book that are overdue
SELECT *
FROM Loans 
WHERE ReturnDate IS NULL;

--members who have books that are overdue
SELECT m.Name, m.ContactNumber
FROM Members m
INNER JOIN Loans l ON m.MemberID = l.MemberID
WHERE l.ReturnDate < CURRENT_DATE;

--Trigger that automatically updates the "Status" column in the "Books" table whenever a book is loaned or returned. 
-- The "Status" should be set to 'Loaned' if the book is loaned and 'Available' if the book is returned.

CREATE TRIGGER UpdateBookStatus
ON Loans
AFTER INSERT
AS
BEGIN
UPDATE Books
SET Status = 'Unavailable'
WHERE BookID = NEW.BookID;
END;

-- A trigger that updates the ReturnDate column of the Loans table when a book is returned

CREATE TRIGGER UpdateLoanDate
ON Loans
AFTER UPDATE
AS
BEGIN
UPDATE Loans
SET ReturnDate = CURRENT_DATE
WHERE LoanID = NEW.LoanID;
END;

-- Create a CTE that retrieves the names of all members who have borrowed at least three books.
WITH CheckedOutBooks AS (
SELECT MemberID, COUNT(*) AS NumBooksBorrowed
FROM Loans
WHERE MemberID = @MemberID
HAVING COUNT (*) >= 3
)
SELECT *
FROM Members
INNER JOIN BorrowedBooks ON Members.MemberID = BorrowedBooks.MemberID;


-- function that calculates the overdue days for a given loan.
CREATE FUNCTION CalculateOverdueDays(@LoanID INT)
RETURNS INT
AS
BEGIN
DECLARE @LoanDate DATE;
DECLARE @ReturnDate DATE;

SELECT @LoanDate = LoanDate, @ReturnDate = ReturnDate
FROM Loans
WHERE LoanID = @LoanID;

DECLARE @OverdueDays INT;

IF @ReturnDate IS NULL
BEGIN
SET @OverdueDays = 0;
END
ELSE
BEGIN
SET @OverdueDays = DATEDIFF(DAY, @LoanDate, CURRENT_DATE);
END

RETURN @OverdueDays;
END;

-- a view that displays the details of all overdue loans, including the book title, member name, and number of overdue days.
CREATE VIEW OverdueLoans
AS
SELECT l.LoanID, b.Title, m.Name, DATEDIFF(DAY, l.LoanDate, CURRENT_DATE) AS OverdueDays
FROM Loans l
INNER JOIN Books b ON l.BookID = b.BookID
INNER JOIN Members m ON l.MemberID = m.MemberID
WHERE l.ReturnDate IS NULL;


-- trigger that prevents members from borrowing three books at a time

CREATE TRIGGER PreventOverThreeBooks
ON Loans
AFTER INSERT
AS
BEGIN
DECLARE @MemberID INT;
DECLARE @BookID INT;

SELECT @MemberID = l.MemberID, @BookID = l.BookID
FROM inserted i
INNER JOIN Loans l ON i.BookID = l.BookID;

DECLARE @NumBooksBorrowed INT;

SELECT @NumBooksBorrowed = COUNT(*)
FROM Loans
WHERE MemberID = @MemberID;

IF @NumBooksBorrowed >= 3
BEGIN
RAISERROR('Member cannot borrow more than 3 books at a time.', 16, 1);
ROLLBACK TRANSACTION;
END;
END;

















