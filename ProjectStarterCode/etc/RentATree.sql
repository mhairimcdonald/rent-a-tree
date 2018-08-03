CREATE TABLE Account( 
	AccountID INT GENERATED ALWAYS AS IDENTITY,
	Email VARCHAR2 (30) NOT NULL,
	Password VARCHAR2(100) NOT NULL,
	DateOfBirth DATE NOT NULL,
	AccountType VARCHAR2(10),
	Hit INT, 
	Miss INT,
	Suspended VARCHAR2(3),
	CONSTRAINT pkAccountID PRIMARY KEY (AccountID),
	CONSTRAINT UniqueEmail UNIQUE (Email),
	CONSTRAINT CheckAccountType CHECK ((AccountType = 'Admin') OR (AccountType = 'User')),
	CONSTRAINT CheckSuspended CHECK ((Suspended = 'Y') OR (Suspended = 'N'))
);


CREATE TABLE CardDetail(
	CardDetailID INT GENERATED ALWAYS AS IDENTITY,
	AccountID INT NOT NULL,
	CardName VARCHAR2 (20) NOT NULL,
	CardNumber VARCHAR2 (16)NOT NULL,
	CardDate INT NOT NULL,
	CardMonth INT NOT NULL,	
	CvCode INT NOT NULL,
	CONSTRAINT pkCardDetailID PRIMARY KEY (CardDetailID),
	CONSTRAINT fkAccountID FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Product(
	ProductID INT GENERATED ALWAYS AS IDENTITY,
	StockLevel INT,
	TreeType VARCHAR2(20),
	Material VARCHAR2(20),
	Height INT,
	Description VARCHAR2(150),
	SupplierName VARCHAR2 (20),
	PricePerDay INT,
	CONSTRAINT pkProductID PRIMARY KEY (ProductID)
);

CREATE TABLE Purchase(
	PurchaseID INT GENERATED ALWAYS AS IDENTITY,
	AccountID INT,
	CardDetailID INT,
	AddressLine VARCHAR2(30),
	Postcode VARCHAR (10),
	OrderConfirmation VARCHAR2(3),
	FinalPrice INT,
	CONSTRAINT fkAccountID2 FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
	CONSTRAINT fkCardDetailID FOREIGN KEY (CardDetailID) REFERENCES CardDetail(CardDetailID),
	CONSTRAINT pkPurchaseID PRIMARY KEY (PurchaseID),
	CONSTRAINT CheckOrderConfirmation CHECK ((OrderConfirmation = 'Y') OR (OrderConfirmation = 'N'))
);

CREATE TABLE ProductOrder(
	ProductOrderID INT GENERATED ALWAYS AS IDENTITY,
	PurchaseID INT,
	ProductID INT,
	Quantity INT,
	LeaseStart DATE, 
	LeaseEnd DATE,
	CollectionType  VARCHAR2(10),
	ReturnType VARCHAR2 (10),
	CollectionSlot VARCHAR2 (3),
	ReturnSlot VARCHAR2(3),
	Collected VARCHAR2(3),
	Returned VARCHAR2 (3),
	Deposit INT,
	CONSTRAINT fkPurchaseID FOREIGN KEY (PurchaseID) REFERENCES Purchase(PurchaseID),
	CONSTRAINT fkProductID FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
	CONSTRAINT pkProductOrderID PRIMARY KEY (ProductOrderID),
	CONSTRAINT CheckCollection CHECK  ((CollectionType = 'Collection') OR (CollectionType = 'Delivery')) ,
	CONSTRAINT CheckReturn CHECK ((ReturnType = 'Collection') OR (ReturnType = 'Delivery')),
	CONSTRAINT CheckCollectSlot CHECK ((CollectionSlot = 'AM') OR (CollectionSlot = 'PM') OR (CollectionSlot = 'ANY')),
	CONSTRAINT checkReturnSlot CHECK ((ReturnSlot = 'AM') OR (ReturnSlot = 'PM') OR (ReturnSlot = 'ANY')),
	CONSTRAINT checkCollected CHECK ((Collected = 'Y') OR (Collected = 'N')),
	CONSTRAINT checkReturned CHECK ((Returned = 'Y') OR (Returned = 'N'))
);

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE UpdateCreditCardDetails(
	newCardName IN CardDetail.CardName%TYPE,
	newCardNumber IN CardDetail.CardNumber%TYPE,
	newCardMonth IN CardDetail.CardMonth%TYPE,	
	newCardDate IN CardDetail.CardDate%Type,
	newCvCode IN CardDetail.CvCode%TYPE,
	newAccountID IN CardDetail.AccountID%TYPE,
	newCardDetailID IN CardDetail.CardDetailID%TYPE
)
IS 

BEGIN
	UPDATE CardDetail
	SET CardName = newCardName, CardNumber = newCardNumber, CardMonth = newCardMonth, CardDate = newCardDate,CvCode = newCvCode, AccountID = newAccountID 
	WHERE CardDetailID = newCardDetailID;

END;
/
	
CREATE OR REPLACE PROCEDURE UpdateStockLevel(
	newStockLevel IN Product.StockLevel%TYPE
)
IS 

BEGIN
	UPDATE Product
	SET StockLevel = newStockLevel;
END;
/ 

		
CREATE OR REPLACE PROCEDURE InsertProductToBasket(
	newPurchaseID IN ProductOrder.PurchaseID%TYPE,
	newProductID IN Product.ProductID%TYPE,
	newQuantity IN ProductOrder.Quantity%TYPE,
	newLeaseStart IN ProductOrder.LeaseStart%TYPE,
	newLeaseEnd IN ProductOrder.LeaseEnd%TYPE
)
IS

BEGIN
	INSERT INTO ProductOrder (PurchaseID,ProductID, Quantity,LeaseStart,LeaseEnd)
		VALUES (newPurchaseID, newProductID, newQuantity, newLeaseStart, newLeaseEnd);
END;
/
--------------------------

CREATE OR REPLACE PROCEDURE insertProductToCheckout(
	newPurchaseID IN Purchase.PurchaseID%TYPE,
	newCollectionType IN ProductOrder.CollectionType%TYPE,
	newReturnType IN ProductOrder.ReturnType%TYPE,
	newCollectionSlot IN ProductOrder.CollectionSlot%TYPE,
	newReturnSlot IN ProductOrder.ReturnSlot%TYPE,
	newDeposit IN ProductOrder.Deposit%TYPE
)
IS

BEGIN
	INSERT INTO ProductOrder (PurchaseID, CollectionType, ReturnType, CollectionSlot, ReturnSlot, Deposit)
		VALUES (newPurchaseID, newCollectionType, newReturnType, newCollectionSlot, newReturnSlot, newDeposit);
END;
/
---------HIT AND MISS PROCEDURES------
CREATE OR REPLACE PROCEDURE IncrementHit(
	newAccountID IN Account.AccountID%TYPE
)
IS	

BEGIN
	UPDATE Account
    SET Hit = Hit + 1
	WHERE AccountID = newAccountID;
END;
/

CREATE OR REPLACE PROCEDURE IncrementMiss(
	newAccountID IN Account.AccountID%TYPE
)
IS

BEGIN
	UPDATE Account 
	SET Miss = Miss + 1
	WHERE AccountID = newAccountID;
END;
/
----------END------------
CREATE OR REPLACE PROCEDURE RemoveAccount(
	newAccountID IN Account.AccountID%TYPE
)
IS

BEGIN
	DELETE FROM ACCOUNT
	WHERE AccountID = newAccountID;
END;
/ 


CREATE OR REPLACE PROCEDURE UpdatePurchase(
	newAddressLine IN Purchase.AddressLine%TYPE,
	newPostcode IN Purchase.Postcode%TYPE,
	newFinalPrice IN Purchase.FinalPrice%TYPE,
	newCardDetailID IN Purchase.CardDetailID%TYPE,
	newPurchaseID IN Purchase.PurchaseID%TYPE
)
IS

BEGIN
	UPDATE Purchase 
	SET AddressLine = newAddressLine, Postcode = newPostcode, OrderConfirmation = 'Y', FinalPrice = newFinalPrice, CardDetailID = newCardDetailID
	WHERE PurchaseID = newPurchaseID;
END;
/	
	
CREATE OR REPLACE PROCEDURE insertAccount(

	newEmail IN Account.Email%TYPE,
	newPassword IN Account.Password%TYPE,
	newDateOfBirth IN Account.DateOfBirth%TYPE,	
	newAccountType IN Account.AccountType%TYPE,
	newHit IN Account.Hit%TYPE,
	newMiss IN Account.Miss%TYPE,
	newSuspended IN Account.Suspended%TYPE,
	newAccountID OUT Account.AccountID%TYPE
	
)
IS 
	invalidEmail EXCEPTION;
 
BEGIN
	IF (newEmail LIKE '_%@_%._%') THEN
		INSERT INTO Account(Email,Password,DateOfBirth,AccountType,Hit,Miss,Suspended)
		VALUES(newEmail,newPassword,newDateOfBirth,newAccountType,newHit,newMiss,newSuspended) RETURNING Account.AccountID INTO newAccountID;
			ELSE
		RAISE invalidEmail;
		END IF;
	--Catch exception in java
END; 
/


CREATE OR REPLACE PROCEDURE insertCardDetail(

	newCardName IN CardDetail.CardName%TYPE,
	newCardNumber IN CardDetail.CardNumber%TYPE,
	newCardMonth IN CardDetail.CardMonth%TYPE,	
	newCardDate IN CardDetail.CardDate%Type,
	newCvCode IN CardDetail.CvCode%TYPE,
	newAccountID IN CardDetail.AccountID%TYPE,
	newCardDetailID OUT CardDetail.CardDetailID%TYPE	
)
IS

BEGIN
	INSERT INTO CardDetail(CardName, CardNumber, CardMonth, CardDate,CvCode, AccountID)
		VALUES (newCardName, newCardNumber, newCardMonth, newCardDate,newCvCode, newAccountID) RETURNING CardDetail.CardDetailID INTO newCardDetailID;
		
END;
/

CREATE OR REPLACE PROCEDURE insertProduct(

	newStockLevel IN Product.StockLevel%TYPE,
	newTreeType IN Product.TreeType%TYPE,
	newMaterial IN Product.Material%TYPE,
	newHeight IN Product.Height%TYPE,
	newDescription IN Product.Description%TYPE,
	newSupplierName IN Product.SupplierName%TYPE,
	newPrice IN Product.PricePerDay%TYPE,
	newProductID OUT Product.ProductID%TYPE

)
IS

BEGIN
	INSERT INTO Product(StockLevel, TreeType,Material,Height,Description,SupplierName,PricePerDay)
		VALUES (newStockLevel,newTreeType,newMaterial,newHeight,newDescription,newSupplierName,newPrice) RETURNING Product.ProductID INTO newProductID;

END;
/

CREATE OR REPLACE PROCEDURE insertPurchase(

	newAddressLine IN Purchase.AddressLine%TYPE,
	newPostcode IN Purchase.Postcode%TYPE,
	newOrderConfirmation IN Purchase.OrderConfirmation%TYPE,
	newFinalPrice IN Purchase.FinalPrice%TYPE,
	newAccountID IN Purchase.AccountID%TYPE,
	newCardDetailID IN Purchase.CardDetailID%TYPE,
	newPurchaseID OUT Purchase.PurchaseID%TYPE
	

)
IS

BEGIN
	INSERT INTO Purchase (AddressLine, Postcode, OrderConfirmation, FinalPrice, AccountID, CardDetailID) 
		VALUES (newAddressLine, newPostCode, newOrderConfirmation, newFinalPrice, newAccountID, newCardDetailID) RETURNING Purchase.PurchaseID INTO newPurchaseID;
END;
/

CREATE OR REPLACE PROCEDURE insertProductOrder(
	newPurchaseID IN ProductOrder.PurchaseID%TYPE,
	newProductID IN ProductOrder.ProductID%TYPE,
	newQuantity IN ProductOrder.Quantity%TYPE,
	newLeaseStart IN ProductOrder.LeaseStart%TYPE,
	newLeaseEnd IN ProductOrder.LeaseEnd%TYPE,
	newCollectionType IN ProductOrder.CollectionType%TYPE,
	newReturnType IN ProductOrder.ReturnType%TYPE,
	newCollectionSlot IN ProductOrder.CollectionSlot%TYPE,
	newReturnSlot IN ProductOrder.ReturnSlot%TYPE,
	newCollected IN ProductOrder.Collected%TYPE,
	newReturned IN ProductOrder.Returned%TYPE,
	newDeposit IN ProductOrder.Deposit%TYPE,
	newProductOrderID OUT ProductOrder.ProductOrderID%TYPE
)
IS

BEGIN
	INSERT INTO ProductOrder(PurchaseID, ProductID, Quantity,LeaseStart,LeaseEnd,CollectionType,ReturnType,CollectionSlot,ReturnSlot,Collected,Returned,Deposit)
			VALUES(newPurchaseID, newProductID, newQuantity,newLeaseStart,newLeaseEnd,newCollectionType,newReturnType,newCollectionSlot,newReturnSlot,newCollected,newReturned,newDeposit) RETURNING ProductOrder.ProductOrderID INTO newProductOrderID;

END;
/
DECLARE
ProductID INT;
AccountID INT;
CardDetailID INT;
PurchaseID INT;
ProductOrderID INT;
BEGIN
--	INSERT INTO Product(StockLevel, TreeType,Material,Height,Description,SupplierName,PricePerDay)
--		VALUES (newStockLevel,newTreeType,newMaterial,newHeight,newDescription,newSupplierName,newPrice) RETURNING Product.ProductID INTO newProductID;

	insertProduct(100,'Pine','Natural',320,'Large, high needle retention, acicular-shaped leaves, approx. 5 needles per bundle','TreesRUs',8, ProductID);
	insertProduct(80,'Pine','Natural',150,'Medium, high needle retention, acicular-shaped leaves, approx. 5 needles per bundle','TreeLovers',6, ProductID);
	insertProduct(100,'Fir','Natural',360,'Large, non-drop, classic symmetrical shape, dark green needles','TreeLovers',5, ProductID);
	insertProduct(90,'Spruce','PE',140,'Medium ,good quality, PE, budget tree, hinged branches, easy assemble, recyclable','TreeCollectors',7, ProductID);
	insertProduct(100,'Cedar','PVC',260,'Medium, classic, contemporary tree, dark emerald green, brighter tips, good quality, recyclable','TreesRUs',9, ProductID);
	insertProduct(80,'Spruce','Natural',400,'Large, sharp needles, delicious pine fragrance, need to be well-watered to minimise needle drop','TreeLovers',10, ProductID);
	insertProduct(75,'Pine','Natural',80,'Small, high needle retention, acicular-shaped leaves, approx. 5 needles per bundle','TreeLovers',4, ProductID);
	insertProduct(90,'Spruce','Natural',200,'Medium, sharp needles, delicious pine fragrance, need to be well-watered to minimise needle drop','TreeCollectors',8, ProductID);
	insertProduct(60,'Cedar','Natural',126,'Medium, cone shape, dark, shiny green, sharp needles','TreesRUs',9, ProductID);
	insertProduct(40,'Fir','PVC',60,'Small, wide, cone shaped, good quality, recyclable, real-feel','TreeLovers',10, ProductID);
	

	
	insertAccount('graham.hall@hotmail.com','g95wq3sCw3BsxdwJFCG1JdDzv4Ie6BFZgsJWKio5Ac=$C8NKI/O6R4iXaVarbceAJlzJHLaW9DIbni1DHSif9SU=','16-JUN-1980','User',1,1,'N', AccountID);
	insertCardDetail('MRS M SMITH','2235776488946647',05,22,122,AccountID,CardDetailID);
	insertPurchase('46 Old Kent Rd','CL13 5AG','Y',80,AccountID,CardDetailID,PurchaseID);
	insertProductOrder(PurchaseID, 3,1,'05-DEC-2017','05-JAN-2018','Delivery','Delivery','ANY','ANY','Y','N',3,ProductOrderID);
	insertProductOrder(PurchaseID, 2, 5,'02-DEC-2017','02-JAN-2018','Collection','Delivery','AM','ANY','N','N',10,ProductOrderID);
	
	
	insertAccount('harry.green@live.co.uk','Zn47lSx1cTXUjXoDqhGyrlEKq2BVplw6woggOstonu0=$dYfojf7d51qnsojS7YlY1BG403nsOhbvZYp8DeWZWnk=','24-MAY-1976','Admin',0,0,'N', AccountID);
	insertCardDetail('MR H GREEN','1234567892345672',01, 20,345, AccountID,CardDetailID);
	insertPurchase('24 Pall Mall','BH15 3AH','Y',40,AccountID,CardDetailID,PurchaseID);
	insertProductOrder(PurchaseID, 1,1,'09-DEC-2017','09-JAN-2018','Delivery','Delivery','PM','ANY','Y','Y',10,ProductOrderID);
	insertProductOrder(PurchaseID, 1,2,'01-DEC-2017','27-DEC-2017','Collection','Collection','ANY','ANY','Y','Y',20,ProductOrderID);
	
	
	insertAccount('stella.smith@gmail.com','g95wq3sCw3BsxdwJFCG1JdDzv4Ie6BFZgsJWKio5Ac=$C8NKI/O6R4iXaVarbceAJlzJHLaW9DIbni1DHSif9SU=','03-AUG-1960','Admin',0,0,'N', AccountID);
	insertCardDetail('MRS S SMITH','0988735627873645',07,22,732,AccountID,CardDetailID);
	insertPurchase('34 Oxford Road','LH72 6SA','Y',80,AccountID,CardDetailID,PurchaseID);
	insertProductOrder(PurchaseID, 3, 1,'10-DEC-2017','04-JAN-2018','Collection','Delivery','AM','ANY','Y','N',20,ProductOrderID);
	insertProductOrder(PurchaseID, 5,2,'14-DEC-2017','04-JAN-2018','Collection','Delivery','ANY','ANY','Y','Y',20,ProductOrderID);
	
	
	insertAccount('ben.jay@gmail.com','g95wq3sCw3BsxdwJFCG1JdDzv4Ie6BFZgsJWKio5Ac=$C8NKI/O6R4iXaVarbceAJlzJHLaW9DIbni1DHSif9SU=','21-JAN-1978','User',1,0,'N', AccountID);
	insertCardDetail('MR B Jay','1122364555341300',09, 25, 322,AccountID,CardDetailID);
	insertPurchase('12 LongFord Ave','SU75 6HA','Y',60,AccountID,CardDetailID,PurchaseID);
	insertProductOrder(PurchaseID, 4, 1,'14-DEC-2017','04-JAN-2018','Collection','Delivery','ANY','ANY','Y','Y',20,ProductOrderID);
	insertProductOrder(PurchaseID, 6, 3,'15-DEC-2017','04-JAN-2018','Collection','Delivery','ANY','ANY','Y','Y',20,ProductOrderID);
	
	
	
END;
/

SET SERVEROUTPUT OFF;


