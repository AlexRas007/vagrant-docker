## Vagrant Docker
Виртуальная машина для запуска докер.

### Команда `$ vagrant vm`:
```
$ vagrant vm files clean # очищает файлы работы полностью
$ vagrant vm reinstall # переустанавливает виртуальную машину с очисткой файлов работы полностью
```

### Команда `$ vagrant docker`:
```
$ vagrant docker container clean # удаление всех контейнеров
$ vagrant docker image clean # удаление всех образов
$ vagrant docker clean # удаление всех образов и контейнеров
$ vagrant docker ... # любые другие команды докера
```

### Пример добавления docker конфигураций из git и запуск:
```
$ cd dockers # переходим в папку dockers там лежат файлы
$ git clone {урл к репозиторию} # клонируем файлы для сборки образа докер
$ vagrant ssh # переходим на сервер по ssh
$ cd dockers/{имя репозитория} # переходим в директорию и можем начнинать работу
```

### Структура:
```
- commands - дополнительные команды vagrant
- dockers - файлы для сборки образов docker размещаются тут
- LICENSE - лицензия
- README.MD - описание
- Vagrantconfig.yaml - конфигурация окружения vagrant
- Vagrantconfig.example.yaml - исходная конфигурация окружения vagrant
- Vagrantfile - конфигурация vagrant
```