---
layout: mypost
title: python3 操作elasticsearch
categories: [python]
---

- 准备篇

安装: [Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/_installation.html)

连接: [ElasticSearch Head](https://chrome.google.com/webstore/detail/elasticsearch-head/ffmkiejjmecolpfloofpjologoblkegm)

建立索引: [文末附录](#)

---

- 安装依赖

``` bash
pip install elasticsearch
```

- 建立连接

``` python
from elasticsearch import Elasticsearch

es = Elasticsearch(["192.168.1.84"],http_auth=("elastic", "elastic"),port=9200)
```

- 写入数据

``` python
doc = {'id': 1, 'lv_id': 12, 'sentiment':0, 'news_id': 1673578, 'review': '错字连篇，受不了，还真的看完了[笑着哭]', 'keyword': '受不了 错字连篇', 'ner': ''}

res = es.index(index="match_review", doc_type='review_feature' ,id=doc['news_id'], body=doc)

print(res['result'])
```

- 批量写入

``` python
from elasticsearch import helpers

actions = []
data = [{'id': 1, 'lv_id': 12, 'sentiment':0, 'news_id': 1673578, 'review': '错字连篇，受不了，还真的看完了[笑着哭]', 'keyword': '受不了 错字连篇', 'ner': ''}, ...]

for doc in data:
    action = {
            "_index": "match_review",
            "_type": "review_feature",
            "_id": doc["news_id"],
            "_source": doc
            }
    actions.append(action)

helpers.bulk(es, actions)
```

- 根据id查询

``` python3
news_id = 1673578
res = es.get(index="match_review", doc_type='review_feature' ,id=news_id)
```

- 查询全部

``` python3
query = es.search(index="match_review", body={"query": {"match_all": {}}}, scroll='5m', size=100)
    res = query['hits']['hits'] # es查询出的结果第一页
    total = query['hits']['total']  # es查询出的结果总量
    scroll_id = query['_scroll_id'] # 游标用于输出es查询出的所有结果
    for i in range(0, int(total/100)+1):
        # scroll参数必须指定否则会报错
        query_scroll = es.scroll(scroll_id=scroll_id,scroll='5m')['hits']['hits']
        res += query_scroll
```

- 按条件搜索

``` python
body = {
    "query":{
        "bool":{
            # lv_id相等, sentiment满足范围-1到1
            "must":[{"term":{"lv_id":lv_id}}, {"range":{"sentiment":{"gte": -1, "lte":1}}}], 
            # ner匹配到一个
            "should": [{"match": {"ner":i}} for i in ["中国"， "美国"]], "minimum_should_match": 1}
        }, 
        # 随机排序
        "sort" : [{"_script" : {"script" : {"source" : "Math.random()","lang" : "painless"},"type" : "number","order" : "asc"}}]
    }
res = es.search(index="match_review", body=body)
```
- 附录 

自定义索引语句(指定分词方式)

```
{       "settings":{
            "analysis":{
                "analyzer":{
                    "my_lowercase_analyzer":{
                        "type":"custom",
                        "tokenizer":"whitespace",
                        "filter":[
                            "lowercase"
                        ]
                    }
                }
            }
        },
        "mappings":{
            "review_feature":{
                "properties":{
                    "id": {
                    "type": "integer"
                    },
                    "keyword": {
                    "type": "text",
                    "analyzer":"my_lowercase_analyzer"
                    },
                    "lv1_id": {
                    "type": "integer"
                    },
                    "ner": {
                    "type": "text",
                    "analyzer":"my_lowercase_analyzer",
                    "fields": {
                    "keyword": {
                    "type": "keyword",
                    "ignore_above": 256
                    }
                    }
                    },
                    "news_id": {
                    "type": "integer"
                    },
                    "review": {
                    "type": "text"
                    },
                    "sentiment": {
                    "type": "integer"
                    }
                }
            }
        }
    }
```