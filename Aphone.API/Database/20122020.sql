USE [NewAphone]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 12/21/2020 9:11:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](500) NOT NULL,
	[IsDelete] [bit] NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 12/21/2020 9:11:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](500) NOT NULL,
	[Price] [int] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[ShortDescription] [nvarchar](500) NOT NULL,
	[Image] [nvarchar](500) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[IsDelete] [bit] NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 12/21/2020 9:11:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Category] ON 
GO
INSERT [dbo].[Category] ([CategoryId], [CategoryName], [IsDelete]) VALUES (1, N'SamSung', 0)
GO
INSERT [dbo].[Category] ([CategoryId], [CategoryName], [IsDelete]) VALUES (2, N'Apple', 0)
GO
INSERT [dbo].[Category] ([CategoryId], [CategoryName], [IsDelete]) VALUES (3, N'nam', 1)
GO
INSERT [dbo].[Category] ([CategoryId], [CategoryName], [IsDelete]) VALUES (4, N'namaaa', 0)
GO
SET IDENTITY_INSERT [dbo].[Category] OFF
GO
ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([CategoryId])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_Category]
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateCategory]    Script Date: 12/21/2020 9:11:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Trinh Nam
-- Create date: 20/12/2020
-- Description:	Create new category
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateCategory]
	@CategoryName NVARCHAR(500)
AS
BEGIN
	DECLARE @CategoryId	INT = 0,
			@Message	NVARCHAR(200) = 'Something went wrong, please contact administrator.'

	BEGIN TRY
		IF(@CategoryName IS NULL OR @CategoryName = '')
		BEGIN
			SET @Message = 'Category name is required.'
		END
		ELSE
		BEGIN
			IF(EXISTS(SELECT * FROM Category WHERE CategoryName = @CategoryName))
			BEGIN
				SET @Message = 'Category name is exists.'
			END
			ELSE
			BEGIN
				INSERT INTO [dbo].[Category]
					   ([CategoryName]
					   ,[IsDelete])
				 VALUES
					   (@CategoryName
					   ,0)

				SET @CategoryId = SCOPE_IDENTITY()
				SET @Message = 'Category has been created success.'
			END
		END
		SELECT @CategoryId AS CategoryId, @Message AS [Message]
	END TRY
	BEGIN CATCH
		SELECT @CategoryId AS CategoryId, @Message AS [Message]
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteCategory]    Script Date: 12/21/2020 9:11:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Trinh Nam
-- Create date: 20/12/2020
-- Description:	Delete category
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteCategory]
	@CategoryId		INT	
AS
BEGIN
	
	DECLARE @Message	NVARCHAR(200) = 'Something went wrong, please contact administrator.'
	DECLARE @Result		BIT = 0
	DECLARE @IsDelete	BIT = 1

	BEGIN TRAN
	BEGIN TRY
		IF(ISNULL(@CategoryId,0) = 0)
		BEGIN
			SET @Message = 'CategoryId is required.'
		END
		ELSE
			BEGIN
				IF(NOT EXISTS(SELECT * FROM Category WHERE CategoryId = @CategoryId))
				BEGIN
					SET @Message = 'Can not found Category Id'	
				END
				ELSE
				IF(EXISTS(SELECT * FROM Category WHERE CategoryId = @CategoryId AND IsDelete = 1))
				BEGIN
					SET @Message = 'Category has been deleted'
				END
				ELSE
				BEGIN
					UPDATE Category
					SET IsDelete = @IsDelete
					WHERE CategoryId = @CategoryId

					SET @Message = 'Category has been delete success'
					SET @Result = 1
				END
		END
		SELECT @Result AS Result, @Message AS [Message] ,@CategoryId AS CategoryId ,@IsDelete AS IsDeleted
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT @Result AS Result, @Message AS [Message],@CategoryId AS CategoryId ,@IsDelete AS IsDeleted
		ROLLBACK TRAN
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCategory]    Script Date: 12/21/2020 9:11:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Trinh Nam
-- Create date: 20/12/2020
-- Description:	GetCategory
-- =============================================
CREATE PROCEDURE[dbo].[sp_GetCategory] 
AS
BEGIN
	SELECT [CategoryId]
		  ,[CategoryName]
	  FROM [dbo].[Category]
	  WHERE IsDelete = 0
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateCategory]    Script Date: 12/21/2020 9:11:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Trinh Nam
-- Create date: 21/12/2020
-- Description:	Update category
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateCategory]
	@CategoryId		INT,
	@CategoryName	NVARCHAR(500)
AS
BEGIN
	
	DECLARE @Message	NVARCHAR(200) = 'Something went wrong, please contact administrator.'
	DECLARE @Result		BIT = 0

	BEGIN TRAN
	BEGIN TRY
		IF(ISNULL(@CategoryId,0) = 0)
		BEGIN
			SET @Message = 'CategoryId is required.'
		END
		ELSE
		BEGIN
			IF(ISNULL(@CategoryName, '') = '')
			BEGIN
				SET @Message = 'Category name is required.'
			END
			ELSE
			BEGIN
				IF(NOT EXISTS(SELECT * FROM Category WHERE CategoryId = @CategoryId))
				BEGIN
					SET @Message = 'Can not found category Id'	
				END
				ELSE
				BEGIN
					IF(EXISTS(SELECT * FROM Category WHERE CategoryName = @CategoryName AND CategoryId <> @CategoryId))
					BEGIN
						SET @Message = 'Category is exists'	
					END
					ELSE
					BEGIN
						UPDATE Category
						SET CategoryName = @CategoryName
						WHERE CategoryId = @CategoryId

						SET @Message = 'Category has been updated success'
						SET @Result = 1
					END
				END
			END
		END
		SELECT @Result AS Result, @Message AS [Message] ,@CategoryId AS CategoryId
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT @Result AS Result, @Message AS [Message],@CategoryId AS CategoryId
		ROLLBACK TRAN
	END CATCH
END
GO
