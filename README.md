# Gitcloudcli

Use Gitcloudcli to operate files in git

## Installation

    $ gem install gitcloudcli

## Usage

First. Create access token for command line 
##### Github
[click here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)
##### Gitee(oschina)
gitcloudcli will support 
in future
##### Gitlab
gitcloudcli will support 
in future

Second. Add token, repo and spacename to gitcloud
```cassandraql
gitcloud space add Github *****.git ****c958
```

Third. Use gitcloud to use this tool
```cassandraql
Commands:
  gitcloud --version, -v     # print the version
  gitcloud delete PATH       # 删除远端文件
  gitcloud help [COMMAND]    # Describe available commands or one specific command
  gitcloud info PATH         # 展示远端文件信息
  gitcloud list              # 展示远端根目录所有文件信息
  gitcloud space [COMMAND]   # 增加，删除，列出当前可操作的Git空间
  gitcloud upload LOCALPATH  # 上传本地文件
```