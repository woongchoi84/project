#!/usr/bin/env python
# coding: utf-8

# In[ ]:


csvFile = 'data.csv'
with open(csvFile, 'r') as fh:
    lines = fh.readlines()
print(lines)


# In[ ]:


for index, line in enumerate(lines):
    print(index, line)


# In[ ]:


for index, line in enumerate(lines):
    print(index, line.replace('\n',''))


# In[ ]:


for index, line in enumerate(lines):
    line = line.replace('\n','')
    name = line.split(',')[0]
    mail = line.split(',')[1]
    year = line.split(',')[2]
    print(name,mail,year)


# In[ ]:


for index, line in enumerate(lines):
    line = line.replace('\n','')
    [name,mail,year] = line.split(',')
    print(name,mail,year)


# In[ ]:




