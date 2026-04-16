# %%
#Importing pandas to clean data
import pandas as pd
import logging as lg 

# %%
lg.basicConfig(filename="../data_cleaning_log.csv",
               level=lg.INFO,
               format='%(asctime)s %(levelname)s %(message)s'
               )

# %%
try:
    lg.info("Loading the Uncleaned Dataset")
    df = pd.read_csv("../data/Messy_Sales_data.csv")
    df.head()
except: FileNotFoundError
lg.error("File not found")

# %%
#Viewing the different data types in the document
#The end result is that date is in string form and needs to be changed into dateformat
#The price needs to be changed into a currency (round off to 2 decimal places)
#The quantity being a float, has to change back into an integer
lg.info("Viewing the different data types in the document")
df.dtypes

# %%
#Converting date string to time
try:
    lg.info("Changing date datatype from string to datetime")
    df['date'] = pd.to_datetime(df['date'], format="%Y-%m-%d")
    df.info()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")

# %%
try:
    lg.info("Changing from integer to float (decimal)")
    df['price'] = df['price'].astype(float)
    df.head()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")

# %%
#Rechecking data types
lg.info("Rechecking data types")
df.info()

# %%
#Looking for duplicates
lg.info("Looking for duplicates")
#We have 2 duplicates in the dataset
df.duplicated().sum()

# %%
#Dropping duplicated entries
try:  
    lg.info("Dropping duplicated entries")
    df.drop_duplicates(inplace=True)
    df.duplicated().sum()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")

# %%
#Counting for empty rows in the dataframe
lg.info("Counting for empty rows in the dataframe")
#Result is 2 empty rows in quantity and 2 in salesperson
df.isna().sum()

# %%
#Showcasing specific empty rows
lg.info("Showcasing specific empty rows")
df[df.isna().any(axis=1)]

# %%
#Filling in the empty salesperson rows
try:
    lg.info("Filling in the empty salesperson rows")
    df['salesperson'] = df.groupby('region')['salesperson'].transform(lambda x: x.fillna(x.mode()[0]))
    df.isna().sum()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")

# %%
#Calculating the average number of chairs
try:
    lg.info("Calculating the average number of chairs")
    avg_chairs = df[df['product'] == 'Chair']['quantity'].mean()
    avg_chairs.round(0)
    lg.info("Filling in the empty chair values")
#Filling in the empty chair values
    df.fillna({'quantity': avg_chairs.round(0)}, inplace=True)
    df.isna().sum()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")

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

# %%
#Inserting revenue column
try:
    lg.info("Inserting revenue column")
    df['revenue'] = df['quantity'] * df['price']
    df.head()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")

# %%
#Adding month column
try:
    lg.info("Adding month column")
    df['month'] = df['date'].dt.month_name()
    df.head()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")

# %%
df.info()

# %%
try:
    lg.info("Exporting Cleaned Dataset")
    lg.info("Data Cleaning Complete")
    df.to_csv("../output/clean_sales.csv", index=False)
    df.to_excel("../output/clean_sales.xlsx", index=False)
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
# %%
#Sales by Region
try:
    lg.info("Reading Cleaned Data for Sales by Region Aggregation")
    sbr = pd.read_csv("../output/clean_sales.csv")
    sbr.tail()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")

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

# %%
sbr

# %%
try:
    lg.info("Saving to sales_by_region.csv")
    sbr.to_csv("../output/sales_by_region.csv", index=False)
    sbr.to_excel("../output/sales_by_region.xlsx", index=False)
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
# %%
#Sales by Product
try:
    lg.info("Reading Cleaned Data for Sales by Product Aggregation")
    sbp = pd.read_csv("../output/clean_sales.csv")
    sbp.tail()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
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
# %%
sbp

# %%
try:
    lg.info("Saving to sales_by_product.csv")
    sbp.to_csv("../output/sales_by_product.csv", index=False)
    sbp.to_excel("../output/sales_by_product.xlsx", index=False)
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
# %%
#Monthly Revenue
try:
    lg.info("Reading Cleaned Data for Monthly Revenue Aggregation")
    mr = pd.read_csv("../output/clean_sales.csv")
    mr.tail()
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
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
# %%
mr

# %%
try:
    lg.info("Saving to monthly_revenue.csv")
    mr.to_csv("../output/monthly_revenue.csv", index=False)
    mr.to_excel("../output/monthly_revenue.xlsx", index=False)
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
# %%
#Sales Person Performance
try:
    lg.info("Reading Cleaned Data for Salesperson Performance Aggregation")
    spp = pd.read_csv("../output/clean_sales.csv")
    spp.tail() 
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")
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
# %%
spp

# %%
try:
    lg.info("Saving to salesperson_performance.csv")
    lg.info("Data Cleaning and Transformation Complete")
    spp.to_csv("../output/salesperson_performance.csv", index=False)
    spp.to_excel("../output/salesperson_performance.xlsx", index=False)
except Exception as e:
    lg.error(f"Something went wrong reason: {e}")

print("Finito Ntate")


