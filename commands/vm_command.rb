# -*- mode: ruby -*-
# vi: set ft=ruby :

# Дополнительная команда vagrant vm
if ARGV[0] == "vm" then
	command = ARGV[1]
	subcommand = ARGV[2]

	# vagrant vm clean-files - очищает файлы работы полностью
	if command == "files" && command == "clean" then
		system("git clean -dfX --exclude=\!\"Vagrantconfig.yaml\" --exclude=\!\".idea/*\" --exclude=\!\".vagrant\"")
		exit
	end

	# vagrant vm reinstall - полностью переустанавливает виртуальную машину с очисткой файлов работы полностью
	if command == "reinstall" then
		system("vagrant destroy -f")
		puts "\n---------------------\n\n"
		system("vagrant vm clean-files")
		puts "\n---------------------\n\n"
		system("vagrant up")
		exit
	end

	puts "Usage: vagrant vm <command>\n\n"
	puts "Commands:"
	puts "	reinstall      переустанавливает виртуальную машину с очисткой файлов работы полностью"
	puts "	files clean    очищает файлы работы полностью"
	exit
end
