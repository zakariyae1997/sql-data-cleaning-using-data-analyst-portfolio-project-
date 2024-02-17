SELECT *
  FROM [PortfolioProject1].[dbo].[NashvilleHousing]


--Standartize data format
SELECT SaleDate, CONVERT(date, SaleDate)
  FROM [PortfolioProject1].[dbo].[NashvilleHousing]

Alter Table NashvilleHousing
add SaleDataConverted date;

Update NashvilleHousing
Set  SaleDataConverted =CONVERT(date, SaleDate)

SELECT SaleDate, SaleDataConverted
  FROM [PortfolioProject1].[dbo].[NashvilleHousing]


--populate propretyadress data( where propretyadress is null)

SELECT *
  FROM [PortfolioProject1].[dbo].[NashvilleHousing]
  --where PropertyAddress is null
  order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from [PortfolioProject1].[dbo].[NashvilleHousing] as a
join [PortfolioProject1].[dbo].[NashvilleHousing] as b
   on a.ParcelID = b.ParcelID 
   and a.uniqueid <> b.uniqueid
   where a.PropertyAddress is null
  order by a.ParcelID

Update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from [PortfolioProject1].[dbo].[NashvilleHousing] as a
join [PortfolioProject1].[dbo].[NashvilleHousing] as b
   on a.ParcelID = b.ParcelID 
   and a.uniqueid <> b.uniqueid



--breaking out adress into individual columns (adress, city, state )
SELECT *
  FROM [PortfolioProject1].[dbo].[NashvilleHousing]

--Select OwnerAddress
--, SUBSTRING(OwnerAddress , 1 , CHARINDEX(' ', OwnerAddress) - 1) as number
--, SUBSTRING(OwnerAddress , 1, CHARINDEX(',', OwnerAddress) - 1) as adresse
--, SUBSTRING(OwnerAddress ,CHARINDEX(',', OwnerAddress)+1,LEN(OwnerAddress)) as City
--FROM [PortfolioProject1].[dbo].[NashvilleHousing]

Alter Table NashvilleHousing
add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set  PropertySplitAddress =SUBSTRING(PropertyAddress , 1, CHARINDEX(',', PropertyAddress) - 1)

Alter Table NashvilleHousing
add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set  PropertySplitCity =SUBSTRING(PropertyAddress ,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))

--*	Simple method
SELECT OwnerAddress
  ,PARSENAME(REPLACE(OwnerAddress,',','.'),3)
  ,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
  ,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
  FROM [PortfolioProject1].[dbo].[NashvilleHousing]

 Alter Table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing
add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


--Change Y adn N to Yes and NO in 'Sold as vacant' field
SELECT SoldAsVacant
,case 

when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
FROM [PortfolioProject1].[dbo].[NashvilleHousing]


SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM [PortfolioProject1].[dbo].[NashvilleHousing]
group by SoldAsVacant

Update NashvilleHousing
Set SoldAsVacant = case 

when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end


--Remove Duplicates

with rownumCTE as(
SELECT *,
	row_number () over ( 
	partition by parcelid,
	propertyaddress, 
	saleprice,
	saledate,
	legalreference

	order by uniqueID
	) row_num
  FROM [PortfolioProject1].[dbo].[NashvilleHousing]
  )
select *
from rownumCTE
where row_num > 1

SELECT *
  FROM [PortfolioProject1].[dbo].[NashvilleHousing]


--Delet Unused Columns

Alter Table NashvilleHousing
drop column Saledate