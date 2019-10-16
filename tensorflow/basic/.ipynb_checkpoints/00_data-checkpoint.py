#!/usr/bin/env python
# coding: utf-8

# ## 기본모듈준비

# In[3]:


import functools
import numpy as np
import tensorflow as tf
print(tf.__version__)
# Make numpy values easier to read.
np.set_printoptions(precision=3, suppress=True)


# In[4]:


TRAIN_DATA_URL = "https://storage.googleapis.com/tf-datasets/titanic/train.csv"
TEST_DATA_URL = "https://storage.googleapis.com/tf-datasets/titanic/eval.csv"

train_file_path = tf.keras.utils.get_file("train.csv", TRAIN_DATA_URL)
test_file_path = tf.keras.utils.get_file("eval.csv", TEST_DATA_URL)


# In[7]:


get_ipython().system('head {train_file_path}')


# In[9]:


LABEL_COLUMN = 'survived'
LABELS = [0, 1]


# In[10]:


def get_dataset(file_path, **kwargs):
  dataset = tf.data.experimental.make_csv_dataset(
      file_path,
      batch_size=5, # Artificially small to make examples easier to show.
      label_name=LABEL_COLUMN,
      na_value="?",
      num_epochs=1,
      ignore_errors=True, 
      **kwargs)
  return dataset

raw_train_data = get_dataset(train_file_path)
raw_test_data = get_dataset(test_file_path)


# In[11]:


def show_batch(dataset):
  for batch, label in dataset.take(1):
    for key, value in batch.items():
      print("{:20s}: {}".format(key,value.numpy()))


# In[12]:


show_batch(raw_train_data)


# In[1]:


batch.items()


# In[ ]:




