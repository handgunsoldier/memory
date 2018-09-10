## 基本概念

### 启动

```bash
export FLASK_ENV=development
flask run
```

可以写一个 shell 脚本 方便使用：

```bash
#!/bin/bash


export FLASK_APP=app
export FLASK_ENV=development

pipenv run flask run
```

### 视图

- 缺省情况下，一个路由只回应 `GET` 请求。
- 视图中转换器类型：

|   类型   |                含义                 |
| :------: | :---------------------------------: |
| `string` | （缺省值） 接受任何不包含斜杠的文本 |
|  `int`   |             接受正整数              |
| `float`  |            接受正浮点数             |
|  `path`  |   类似 `string` ，但可以包含斜杠    |
|  `uuid`  |          接受 UUID 字符串           |

