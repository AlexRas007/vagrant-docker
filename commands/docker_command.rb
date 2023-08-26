# -*- mode: ruby -*-
# vi: set ft=ruby :

# Дополнительная команда vagrant vm
if ARGV[0] == "docker" then
	command = ARGV[1]
	subcommand = ARGV[2]

	# vagrant docker container clean - удаление всех контейнеров
	if command == "container" && subcommand == "clean" then
		system("vagrant ssh -c \"docker stop $(docker ps -a -q) && docker rm -v $(docker ps -a -q)\"")
		exit
	end

	# vagrant docker image clean - удаление всех образов
	if command == "image" && subcommand == "clean" then
		system("vagrant ssh -c \"docker rmi $(docker images -a -q) && docker system prune --force --volumes\"")
		exit
	end

	# vagrant docker clean - удаление всех образов и контейнеров
	if command == "clean" then
		system("vagrant docker container clean && vagrant docker image clean")
		exit
	end

	# vagrant docker - ретрансляция команд docker в виртуальную машину
	if command != "--help" then
		system("vagrant ssh -c \"" + ARGV.join(" ") + "\"")
		exit
	end

	puts "Usage: vagrant docker <command>\n\n"
	puts "Commands:"
	puts "	container clean      удаление всех контейнеров"
	puts "	image clean          удаление всех образов"
	puts "	clean                удаление всех образов и контейнеров"
	puts "	...                  любые другие команды докера"
	exit
end
