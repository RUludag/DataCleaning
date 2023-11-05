/*

Cleaning Data in SQL Queries

*/


Select *
From NAshville.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From NAshville.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET saleDateConverted = CONVERT(Date,SaleDate)

--Populate PropertyAddress Data
Select PropertyAddress
From NAshville.dbo.NashvilleHousing
Where PropertyAddress is null

Select *
From NAshville.dbo.NashvilleHousing
Where PropertyAddress is null

Select *
From NAshville.dbo.NashvilleHousing
Order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NAshville.dbo.NashvilleHousing a
Join NAshville.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
And a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
From NAshville.dbo.NashvilleHousing a
Join NAshville.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
And a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

Select PropertyAddress
From NAshville.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID
-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From NAshville.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From NAshville.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select OwnerAddress
From NAshville.dbo.NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From NAshville.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From NAshville.dbo.NashvilleHousing


Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From NAshville.dbo.NashvilleHousing 
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
  Case When SoldAsVacant='Y' Then 'Yes'
       When SoldAsVacant='N' Then 'No'
       Else SoldAsVacant
       end
  From NAshville.dbo.NashvilleHousing

  Update NashvilleHousing
   Set SoldAsVacant= Case When SoldAsVacant='Y' Then 'Yes'
       When SoldAsVacant='N' Then 'No'
       Else SoldAsVacant
       end



	   ----Remove duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NAshville.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From NAshville.dbo.NashvilleHousing


--Delete unused Columns

Select *
From NAshville.dbo.NashvilleHousing

Alter Table NAshville.dbo.NashvilleHousing
Drop Column Taxdistrict,PropertyAddress


Alter Table NAshville.dbo.NashvilleHousing
Drop Column SaleDate
