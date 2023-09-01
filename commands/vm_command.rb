# -*- mode: ruby -*-
# vi: set ft=ruby :

# Дополнительная команда vagrant vm
if ARGV[0] == "vm" then
	command = ARGV[1]
	subcommand = ARGV[2]

	# vagrant vm reinstall - полностью переустанавливает виртуальную машину
	if command == "reinstall" then
		system("vagrant destroy -f")
		puts "\n---------------------\n\n"
		system("vagrant up")
		exit
	end

	puts "Usage: vagrant vm <command>\n\n"
	puts "Commands:"
	puts "	reinstall      переустанавливает виртуальную машину"
	exit
end
