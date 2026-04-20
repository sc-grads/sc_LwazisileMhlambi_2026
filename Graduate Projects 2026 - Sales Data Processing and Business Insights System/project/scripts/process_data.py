# %%
#Importing pandas to clean data
import pandas as pd
import logging as lg
import time 

# %%
lg.basicConfig(filename="../data_cleaning_log.csv",
               level=lg.INFO,
               format='%(asctime)s %(levelname)s %(message)s'
               )

# %%
print("""
---------------------------------------------     
Loading the Dataset...
---------------------------------------------      
""")
time.sleep(1.5)

try:
    lg.info("Loading the Uncleaned Dataset")
    df = pd.read_csv("../data/Messy_Sales_data.csv")
    print("""
---------------------------------------------     
Dataset Loaded Successfully
---------------------------------------------      
""")
except: FileNotFoundError
lg.error("File not found")
time.sleep(1.5)
print(df)

# %%
#Viewing the different data types in the document
#The end result is that date is in string form and needs to be changed into dateformat
#The price needs to be changed into a currency (round off to 2 decimal places)
#The quantity being a float, has to change back into an integer
print("""
---------------------------------------------     
Viewing Different Data Types...
---------------------------------------------      
""")

lg.info("Viewing the different data types in the document")
time.sleep(1.5)
print(df.dtypes)

# %%
#Converting date string to time
print("""
---------------------------------------------     
Converting date string to time
---------------------------------------------      
""")
time.sleep(1.5)
try:
    lg.info("Changing date datatype from string to datetime")
    df['date'] = pd.to_datetime(df['date'], format="%Y-%m-%d")
    print("""
---------------------------------------------     
Date Column Converted Successfully
---------------------------------------------      
""")
    print(df.info())
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)

# %%
print("""
---------------------------------------------     
Changing Price into Float
---------------------------------------------      
""")
time.sleep(1)
try:
    lg.info("Changing from integer to float (decimal)")
    df['price'] = df['price'].astype(float)
    df.head()
    print("""
---------------------------------------------     
Price Column Changed Successfully
---------------------------------------------      
""")
    time.sleep(1)
    print(df.head())
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)

# %%
#Rechecking data types
print("""
---------------------------------------------     
Rechecking Data Types
---------------------------------------------      
""")
time.sleep(1)
lg.info("Rechecking data types")
time.sleep(1)
print(df.info())

# %%
#Looking for duplicates
print("""
---------------------------------------------     
Looking For Duplicates
---------------------------------------------      
""")
lg.info("Looking for duplicates")
#We have 2 duplicates in the dataset
dupe = df.duplicated().sum()
time.sleep(1.5)
print(f"""
---------------------------------------------     
{dupe} duplicates have been found!
---------------------------------------------      
""")

# %%
#Dropping duplicated entries
print("""
---------------------------------------------     
Dropping Duplicates
---------------------------------------------      
""")
time.sleep(1)
try:  
    lg.info("Dropping duplicated entries")
    df.drop_duplicates(inplace=True)
    print("""
---------------------------------------------     
Duplicates have been dropped!
---------------------------------------------      
""")
    df.duplicated().sum()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)

# %%
#Counting for empty rows in the dataframe
print("""
---------------------------------------------     
Counting Empty Rows...
---------------------------------------------      
""")
time.sleep(1)
lg.info("Counting for empty rows in the dataframe")
#Result is 2 empty rows in quantity and 2 in salesperson
print(df.isna().sum())

# %%
#Showcasing specific empty rows
print("""
---------------------------------------------     
Displaying Specific Empty Rows
---------------------------------------------      
""")
time.sleep(1)
lg.info("Showcasing specific empty rows")
empty_rows = df[df.isna().any(axis=1)]
print(empty_rows)

# %%
#Filling in the empty salesperson rows
print("""
---------------------------------------------     
Filling Empty Salesperson Rows
---------------------------------------------      
""")
time.sleep(1)
try:
    lg.info("Filling in the empty salesperson rows")
    df['salesperson'] = df.groupby('region')['salesperson'].transform(lambda x: x.fillna(x.mode()[0]))
    df.isna().sum()
    print("""
---------------------------------------------     
Empty Rows Filled Successfully
---------------------------------------------      
""")
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)

# %%
#Calculating the average number of chairs
print("""
---------------------------------------------     
Calculating Average No. of Chairs
---------------------------------------------      
""")
time.sleep(1)
try:
    lg.info("Calculating the average number of chairs")
    avg_chairs = df[df['product'] == 'Chair']['quantity'].mean()
    avg_chairs.round(0)
    print("""
---------------------------------------------     
Filling In Empty Chairs...
---------------------------------------------      
""")
    lg.info("Filling in the empty chair values")
#Filling in the empty chair values
    df.fillna({'quantity': avg_chairs.round(0)}, inplace=True)
    print("""
---------------------------------------------     
Empty Chairs Filled Successfully!
---------------------------------------------      
""")
    df.isna().sum()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)

# %%
df

# %%
#Resetting the index
try:
    lg.info("Resetting the index")
    df =df.reset_index(drop=True)
    df.head()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)

# %%
#Inserting revenue column
print("""
---------------------------------------------     
Inserting Revenue Column...
---------------------------------------------      
""")
try:
    lg.info("Inserting revenue column")
    df['revenue'] = df['quantity'] * df['price']
    df.head()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)

# %%
#Adding month column
print("""
---------------------------------------------     
Adding Month Column
---------------------------------------------      
""")
try:
    lg.info("Adding month column")
    df['month'] = df['date'].dt.month_name()
    df.head()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)

# %%
df.info()

# %%
print("""
---------------------------------------------     
Exporting Cleaned Dataset...
---------------------------------------------      
""")
time.sleep(1)
try:
    lg.info("Exporting Cleaned Dataset")
    lg.info("Data Cleaning Complete")
    df.to_csv("../output/clean_sales.csv", index=False)
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)
# %%
print("""
---------------------------------------------     
Performing Data Aggregations...
---------------------------------------------      
""")
time.sleep(1)
#Sales by Region
try:
    lg.info("Reading Cleaned Data for Sales by Region Aggregation")
    sbr = pd.read_csv("../output/clean_sales.csv")
    sbr.tail()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)

# %%
try:
    lg.info("Aggregating Sales by Region")
    sbr = sbr.groupby('region').agg(
        total_sales_revenue = ('revenue', 'sum'),
        total_quantity_sold = ('quantity', 'sum'),
        total_number_of_orders = ('transaction_id', 'count'),
        average_sales_revenue = ('revenue', 'mean')).round(2).reset_index()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)

# %%
sbr

# %%
try:
    lg.info("Saving to sales_by_region.csv")
    sbr.to_csv("../output/sales_by_region.csv", index=False)
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)
# %%
#Sales by Product
try:
    lg.info("Reading Cleaned Data for Sales by Product Aggregation")
    sbp = pd.read_csv("../output/clean_sales.csv")
    sbp.tail()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)
# %%
try:
    lg.info("Aggregating Sales by Product")
    sbp = sbp.groupby('product').agg(
        total_sales_revenue = ('revenue', 'sum'),
        total_quantity_sold = ('quantity', 'sum'),
        total_number_of_orders = ('transaction_id', 'count'),
        average_sales_revenue = ('revenue', 'mean')).round(2).reset_index()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)
# %%
sbp

# %%
try:
    lg.info("Saving to sales_by_product.csv")
    sbp.to_csv("../output/sales_by_product.csv", index=False)
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)
# %%
#Monthly Revenue
try:
    lg.info("Reading Cleaned Data for Monthly Revenue Aggregation")
    mr = pd.read_csv("../output/clean_sales.csv")
    mr.tail()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)
# %%
try:
    lg.info("Aggregating Monthly Revenue")
    mr = mr.groupby('month').agg(
        total_sales_revenue = ('revenue', 'sum'),
        total_quantity_sold = ('quantity', 'sum'),
        total_number_of_orders = ('transaction_id', 'count'),
        average_sales_revenue = ('revenue', 'mean')).round(2).reset_index()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)
# %%
mr

# %%
try:
    lg.info("Saving to monthly_revenue.csv")
    mr.to_csv("../output/monthly_revenue.csv", index=False)
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)
# %%
#Sales Person Performance
try:
    lg.info("Reading Cleaned Data for Salesperson Performance Aggregation")
    spp = pd.read_csv("../output/clean_sales.csv")
    spp.tail() 
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)
# %%
try:
    lg.info("Aggregating Salesperson Performance")
    spp = spp.groupby(['salesperson', 'product']).agg(
        total_sales_revenue = ('revenue', 'sum'),
        total_quantity_sold = ('quantity', 'sum'),
        total_number_of_orders = ('transaction_id', 'count'),
        average_sales_revenue = ('revenue', 'mean')).round(2).reset_index()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)
# %%
spp

# %%
try:
    lg.info("Saving to salesperson_performance.csv")
    lg.info("Data Cleaning and Transformation Complete")
    spp.to_csv("../output/salesperson_performance.csv", index=False)
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
    print(e)

print(f"""
---------------------------------------------     
Data Aggregations Complete!
---------------------------------------------      
""")
time.sleep(0.5)

print("""
---------------------------------------------
Finito Ntate🎆🎆
---------------------------------------------
""")


