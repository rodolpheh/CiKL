# CiKL

## What is it ?

CiKl is an Android application allowing users to consult nutritional facts for more than 2500 products. The data is coming from the [Ciqual](https://pro.anses.fr/tableciqual/) table, published every year by the ANSES. The RDI values are coming from the [REGULATION (EU) No 1169/2011](http://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=CELEX:02011R1169-20140219).

## What can it do ?

With this application, you can consult the whole Ciqual table and see, for each product, the nutrients that it provides and compare it to the RDI. You can change the quantity of the product to check how much you've eaten (for example, how much sugar in 330g - this is one can - of Coke. Really, check it, you would be surprised*).

You can also sort and search products by group or by nutrient (but not both for the moment). For example, you can check what food has the most B12 vitamin.

\* Spoiler alert : it is equal to one third of the amount of sugar we should eat every day !

## How to build ?

Pull the git repository and open it in QtCreator. If you already have configured QtCreator to build Android application for your phone, you should be able to build it straight away.

On the first start, you should press "Synchroniser" in the alt-menu to build the database. A restart of the application might be necessary as well.

## Why doing this ? Isn't there other applications like this ?

Yes, there is other applications like this. But they are not open source, and they don't always quote their sources.
