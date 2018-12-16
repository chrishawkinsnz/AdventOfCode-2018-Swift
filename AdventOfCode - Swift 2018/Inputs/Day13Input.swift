//
//  Day1Input.swift
//  AdventOfCode2017Day1
//
//  Created by Chris Hawkins on 26/12/17.
//  Copyright © 2017 Chris Hawkins. All rights reserved.
//

import Foundation

let day13InputSimple = """
/->-`########
|###|##/----`
|#/-+--+-`##|
|#|#|##|#v##|
`-+-/##`-+--/
##`------/###
"""
let day13Input = """
/------------------------------------`###################/----------------------------------------------------------------------------------`#########
|####################################|###################|###################################/----------------------------------------------+`########
|####################################|###################|###################################|############/--------------`##################||########
|####################################|#############/-----+------------------`################|############|##############|##################||########
|##############/---------------------+-------------+-----+------------------+------------`###|############|##############|##################||########
|##############|#####################|#############|#####|##################|############|###|/-----------+--------------+------------------++`#######
|##############|####/------------`###|#############|#####|##################|############|###||###########|##############|##################|||#######
|#/------------+----+------------+---+-------------+----`|##################|#####/------+---++-----------+-------`######|##################|||#######
|#|############|####|######/-----+---+-------------+----++------------------+-----+------+---++-----------+-------+------+-------`##########|||#######
|#|############|####|######|#####|###|#############|####||##################|#####|######|###||###/-------+-------+------+--`####|######/---+++---`###
|#|############|####|######|#####|###|#############|####||##################|#####|#####/+---++---+-------+--`####|######|##|####|######|###|||###|###
|#|############|####|######|#####|###|#############|####||###/--------------+-----+-----++---++---+-------+--+-`##|######|##|####|######|###|||###|###
|#|/-----------+----+------+-----+---+-------------+----++---+----------`###|#####|#####||###||###|#######|##|#|##|######|##|/---+------+---+++---+-`#
|#||##########/+----+------+-----+---+-------------+----++---+----------+---+-----+-----++---++---+-------+--+-+-`|######|##||###|######|###|||###|#^#
|#||##########||####|######|#####|##/+-------------+----++---+----------+--`|#####|#####||###||###|#######|##|#|#||/-----+--++---+------+-`#|||###|#|#
|#||##########||##/-+---->-+-----+--++-------------+----++---+----------+--++-----+-----++---++---+-------+--+-+-+++`####|##||###|######|#|#|||###|#|#
|#||##########||##|#|######|###/-+--++--`##########|####||###|#########/+--++-----+-----++`##||###|#######|##|#|#||||####|##||###|######|#|#|||###|#|#
|#||##########||##|#|#####/+---+-+--++--+----------+----++---+---------++--++-----+-----+++--++---+-------+--+-+-++++---`|##||###|######|#|#|||###|#|#
|#||##########||##|#|#####||#/-+-+--++--+----`#####|####||###|#########||##||#####|#####|||##`+---+-------+--+-+-++++---++--++---+------+-+-+/|###|#|#
|#||##########||##|#|#####|`-+-+-+--++--+----+->---+----++---+---------++--++-----+-----+++---+---+-------+--+-+-++++---++--++---/######|#|#|#|###|#|#
|#||##########||##|#|#####|##|#|#|##||##|####|#####`----++---+---------++--+/#####|#####|||###|###|#######|##|#|#||||###||##||##########|#|#|#|###|#|#
|#||##########||##|#|#####|##|#|#|##||##|##/-+----------++---+-`#######||##|######|#####|||###|###|#######|##|#|#||||###||##||##########|#|#|#|###|#|#
|#||##########||##|#|#####|##|#|#|##||##|##|#|##########||###|#|#######||#/+------+---`#|||###|###|#######|##|#|#||||###||##||##########|#|#|#|###|#|#
|#||##########||##|#|#####|##|#|#|##||##|##|#|##########||###|#|#######||#||######|###|#|||###`---+-------+--+-+-++++---++--++----------+-+-+-/###|#|#
|#||##########||##|#|#####|##|#|#|/-++--+--+-+----------++`##|#|#######||#||#/----+---+-+++-------+-------+--+-+-++++---++--++---------`|#|#|#####|#|#
|/++----------++--+-+-----+--+-+-++-++--+--+-+----------+++--+-+-------++-++-+----+---+-+++-------+------`|##|#|#||||###||##||#########||#|#|#####|#|#
||||##########|`--+-+-----+--+-+-++-++--+--+-+----------+++--+-+-------++-++-+----+---+-+/|#######|######||##|#|#||||###||##||#########||#|#|#####|#|#
||||##########|###|#|##/--+--+-+-++-++--+--+-+----------+++--+-+-------++-++-+----+---+-+-+-------+------++--+-+`||||###||##||#########||#|#|#####|#|#
||||###/------+---+-+--+--+--+-+-++-++--+--+-+----------+++--+-+-------++-++-+----+---+-+-+-`#####|######||##|#||||||###||##||#########||#|#|#####|#|#
||||###|######|###|#|##|##|##|#|#||/++--+--+-+----------+++--+-+`#/----++-++-+----+---+-+-+-+-----+---`##||##|#||||||###||##||#########||#|#|#####|#|#
||||###|######|###|#|##|##|##|#|#|||||##|##|/+----------+++--+-++-+--`#||#||#|####|###|#|#|#|#####|###|##|`--+-++++++---+/##||#########||#|#|#####|#|#
||||###|######|###|#|##|##|##|#`-+++++--/##|||##########|||#/+-++-+--+-++-++-+----+---+-+-+-+-----+---+--+---+-++++++---+---++-`#######||#|#|#####|#|#
||||###|######|###|#|##|##|##|###|||||#####|||##########|||#||#||#|#/+-++-++-+----+---+-+-+-+`####|###|##|###|#||||||###|###||#|#######||#|#|#####|#|#
||||###|######|###|#|##|##|##|###|`+++-----+++----------++/#||#||#|#||#||#||#`----+---+-+-+-++----+---+--+---+-++++++---+---++-+-------/|#|#|#####|#|#
||||###|######|###|#|##|##|##|###|#|||#####|||########/-++--++-++-+-++-++-++------+---+-+-+-++----+---+--+---+-++++++---+---++-+--`#####|#|#|#####|#|#
||||###|######|###|#|##|##|##|###|#|||/----+++--------+-++--++-++-+-++-++-++------+---+-+-+-++----+---+--+--`|#||||||###|###||#|##|#####|#|#|#####|#|#
`+++---+------+---+-+--+--+--+---+-++/|####|||########|#||##||#||/+-++-++-++------+---+-+-+-++----+---+-`|##||#||||||###|###||#|##|#####|#|#|#####|#|#
#|||#/-+------+---+-+--+--+--+---+-++-+----+++--`#####|#||##||#||||#||#||#||######|###|#|#|#||####|###|#||##||#||||||###|###||#|##|#####|#|#|#####|#|#
#|||#v#|######|###|#|##|##|##|###|#||#|/---+++--+-`###|#||##||#||||#||#||#||######|/--+-+-+-++----+---+-++--++-++++++---+---++-+--+-----+-+-+--`##|#|#
#|||#|#|###/--+---+-+--+--+--+---+-++-++---+++--+-+---+-++--++-++++-++-++-++------++--+-+-+-++----+---+-++--++-++++++--`|###||#|##|#####|#|#|##|##|#|#
#|||#|#|###|##|###|#|##|##|##|###|#||#||/--+++--+-+---+-++--++-++++-++-++-++------++--+-+-+-++----+---+-++--++`||||||##||###||#|##|#####|#|#|##|##|#|#
#|||#|#|###|/-+---+-+--+--+-`|###|#||#|||##|||##|#|###|#||##||#||||/++-++-++------++--+-+-+-++----+---+-++--+++++++++--++---++-+--+---`#|#|#|##|##|#|#
#|||#|#|###||#|###|#|##`--+-++---+-++-+++--+++--+-+---+-++--++-+++++++-++-++------++--+-+-+-++----+---+-++--++++/||||##||###||#|##|###|#|#|#|##|##|#|#
#|||#|#|###||#|###|#|#####|#||###|#||#|||/-+++--+-+---+-++--++-+++++++-++-++------++--+-+-+-++----+---+-++--++++-++++--++-`#||#|##|###|#|#|#|##|##|#|#
#|||#|#|###||#|###|#|#####|#||###|#||#||||#|||##|#|###|#||##||#|||||||#||#||######||##|#|#|#||####|###|#||##||||#||||##||#|#||#|##|###|#|#|#|##|##|#|#
#|||#|/+---++-+---+-+----`|#||###|#||#||||#|||##|#|##/+-++--++-+++++++-++-++--`###||##|#|#|#||####`---+-++--++++-++++--++-+-/|#|##|###|#|#|#|##|##|#|#
#|||#|||###||#|###|#|####||#||###|#||#||||#|||##|#|##||#||##||#|||||||#||#||##|###||##|#|#|#||########|#||##||||#||||##||#|##|#|##|###|#|#|#|##|##|#|#
#`++-+++>--++-+---+-+----++-++---+-++-++++-+++--+-+--++-++--++-+++++++-++-++--+---++--+-+-+-++--------+-+/##||||#||||##||#|##|#|##|###|#|#|#|##|##|#|#
##||#|||###||#|#/-+-+----++-++---+-++-++++-+++--+-+--++-++-`||#|||||||#||#||##|###||##|#|#|#||########|#|###||||#||||##||#|##|#|##|###|#|#|#|##|##|#|#
##||#|||###||#|#|#|#|####||#||###|#||#||||#`++--+-+--++-++-+++-/||||||#||#||##|###||##|#|#|#||########|#|###||||#||||##||#|##|#|##|###|#|#|#|##|##|#|#
##||#|||###||#|/+-+-+----++-++-`#|#||#||||##||##|#|##||#||#|||##||||`+-++-++--+---++--+-+-+-+/########|#|###||||#||||##||#|##|#|##|###|#|#|#|##|##|#|#
##||#|||###||#|||#|#|####||#||/+-+-++-++++--++--+-+--++-++-+++--++++-+-++-++--+---++--+-+-+-+---------+-+---++++-++++--++-+--+`|##|###|#|#|#|##|##|#|#
##||#|||###||#|||#|#|####||#||||#|#||#||||##||#/+-+--++-++-+++--++++-+-++-++--+---++--+-+-+-+---------+-+---++++-++++--++`|##`++--+---+-+-+-+--+--+-/#
##||#|||###||#|||#|#|#/--++-++++`|#||#||||##||/++-+--++`||#|||##||||#|#||#||##|###||##|#|#|#|##/------+-+---++++-++++--++++`##||##|###|#|#|#|##|##|###
##||#|||###||#|||/+-+-+--++-++++++-++-++++--+++++-+--+++++-+++--++++-+-++-++--+---++--+`|#|#|##|######|#|###||||#||||##|||||/-++--+---+-+-+-+`#|##|###
##|`-+++---++-+++++-+-+--++-++++++-++-++++--+++++-+--+++++-+++--++++-+-+/#||##|###||##|||#|#|##|######|#|###||||#||||##||||||#||##|###|#|#|#||#|##|###
##|##|||###||#|||||#|#|##||#||||||#||#||||##|||||#|##|||||#|`+--++++-+-+--++--+---++--+++-+-+--+------+-+---++++-++++--++++++-+/##|###|#|#|#||#|##|###
##|##|||###||#|||||#|#|##||#||||||#||#||||##|||||#|##|`+++-+-+--++++-+-+--++--+---++--+++-+-+--+------+-+---++++-++++--++++++-+---/###|#|#|#||#|##|###
##`--+++---++-+++++-+-+--++-++++++-++-++++--+++++-+--+-+/|#|#|##||||#|#|##||##|/--++--+++-+-+--+------+-+---++++-++++--++++++-+--`####|#|#|#||#|##|###
#####|||###||#|||||#|#|##||#||||||#||#||||##|||||#|##|#|#|#|#|##||||#|#|##||##||#/++--+++-+-+--+--`###|#|###||||#||||##||||||#|##|####|#|#|#||#|##|###
#####|||###||#|||||#|#|##||#||||||#||#|||`--+++++-+--+-+-+-+-+--++++-+-+--++--++-+++--+++-+-+--+--+---+-+---++++-++++--+++/||#|##|####|#|#|#||#|##|###
#####|||###||#|||||#|#|##||#||||||/++-+++---+++++-+--+`|#|#|#|##|||`-+-+--++--++-+++--+++-+-+--+--+---+-+---++++-++++--+++-++-+--+----/#|#|#||#|##|###
#####|||##/++-+++++-+-+--++-+++++++++-+++---+++++-+-`|||#|#|#|##|||##|/+--++--++-+++--+++-+-+--+--+---+-+-`#||||#||||##|||#||#|##|######|#|#||#|##|###
####/+++--+++-+++++-+-+--++-+++++++++-+++--`|||||#|#||||#|#|#|#/+++--+++--++--++-+++--+++-+-+--+--+---+-+-+-++++-++++--+++-++-+-`|######`-+-++-+--/###
####||||##|||#|||||#|#|##||#|||||||||#|||##||||||#|#||||#`-+-+-++++--+++--++--++-+++--+++-+-+--+--+---+-+-+-++++-++++->+++-++-+-++--------+-/|#|######
####||||##|||#|||||#|#|##||#|||||||||#|||##||||||#|#||||###|#|#||||##|||##||##||#|||##|||#|#|/-+--+---+-+-+-++++-++++--+++-++-+-++--------+--+-+--`###
####||||##|||#|||||#|#|##||#|||||||||#|||##||||||#|#||||###|#|#|||`--+++--++--++-+++--+++-+-++-+--+---/#|#|#||||#||||##|||#||#|#||########|##|#|##|###
####||||##|||#|||||#|#|##||#||||||||^#|||##||||||#|#||||###|/+-+++---+++--++--++-+++--+++-+-++-+--+-----+-+-++++-++++--+++-++-+-++--------+--+-+--+-`#
####||||##|||#|||||#|#|##||#|||||||||#|||##||||||#|#||||###|||#|||###|||##||##||#|v|#/+++-+-++-+--+-----+-+-++++-++++--+++-++-+-++--`#####|##|#|##|#|#
####||||##|||#|||||#|#|##||/+++++++++-+++--++++++`|#||||###|||#|||###|||##||##||#|||#||||#|#||#|##|#####|#|#||||#||||##|||#||#|#||##|#####|##|#|##|#|#
####||||##|||#|||||#|#|##||||||||||||#|||#/++++++++-++++---+++-+++---+++--++--++-+++-++++-+-++-+--+-----+-+-++++-++++--+++-++-+-++--+-----+--+-+--+`|#
####||||##|||#|||||#|#|##||||||||||||#|||#|||||||||#||||###|||#|||###|||##||##||#|||#||||#|#||#|##|#####|#|#||||#||||##|||#||#|#||##|#####|##|#|##|||#
####||||##|||#|||||#|/+--++++++++++++-+++-+++++++++-++++-`/+++-+++---+++--++--++-+++-++++-+-++-+--+-----+-+-++++-++++--+++-++-+>++-`|#####|##|#|##|||#
####||||##|||#|||||#|||##|`++++++++++-+++-+++++++++-++++-+++++-+++---+++--++--++-+++-++++-+-++-+--+-----+-+-++++-++++--+/|#||#|#||#||#####|##|#|##|||#
####||||##|||#|||||#||`--+-+++++/||||#|||#|||||||||#||||#|||||#|||###|||##||##||#|||#||||#|#||#|##|#####|#|#||||#||`+--+-+-++-+-++-++-----/##|#|##|||#
####||||##|||#||`++-++---+-+++++-++++-+++-+++++++++-++++-++/||#|||###|||##||##||#|||#||||#|#||#|##|#####|#|#||||#||#|##|#|#||#|#||#||########|#|##|||#
####||||##|||#||#||#||###|#|||||#|||`-+++-+++++++++-++++-++-++-+++---+++--+/##||/+++-++++-+-++-+--+-----+-+-++++-++-+--+-+-++-+-++-++-`######|#|##|||#
####||||##|||#||#||#||###|#|||||#|||##|||#|||||||||#||||#||#||#|||###|||##|###||||||#||||#|#||#|##|#####|/+-++++-++-+--+-+-++-+-++-++-+------+-+`#|||#
####||||##|||#||#|`-++---+-+++++-+++--+++-+++++++++-++++-++-++-+++---+++--+---++++++-++++-+-++-+--+-----+++-++++-++-/##|#|#||#|#||#||#|######|#||#|||#
#/--++++--+++-++-+--++---+-+++++-+++--+++-+++++++++-++++-++-++-+++---+++--+---++++++-++++-+-++-+--+--`##|||#||||#||####|#|#||#|#||#||#|######|#||#|||#
#|##||||/-+++-++-+--++---+-+++++-+++--+++-+++++++++-++++-++-++-+++---+++--+--`||||||#`+++-+-++-+--+--+--+++-++++-++----+-+-++-+-++-+/#|######|#||#|||#
#|##|||||#|||#||#|##||###|#|||||#|||##|||#|||||||||#||||#||#||#|||###|||##|##|||||||##||`-+-++-+--+--+--+++-+/||#||####|#|#||#|#||#|##|######|#||#|||#
#|##|`+++-+++-++-+--++---+-+++++-+++--+++-++++++/||#||||#||#|`-+++---+++--+--+++++++--++--+-++-+--+--+--+++-+-+/#||####|#|#||#|#||#|##|######|#||#|||#
#|##|#|||#|||#||#|##||###|#|||||#|||##|||#||`+++-++-++++-++-+--+++---/||##|##|||||||##||##|#||#|##|##|##|||#|#|##||####|#|#||#|#||#|##|######|#||#|||#
#|/-+-+++-+++-++-+--++---+-+++++`|||##|||#`+-+++-++-++++-++-+--+++----++--+--+++++++--++--+-++-+--+--+--+++-+-+--++----+-+-++-+-++-+->+------+-++-+/|#
#||#|#|||#|||#||#|##||###|#|||||||||##|||##|#|||#||#||||#||#|##||`----++--+--+++++++--++--+-++-+--+--+--/||#|#|##||####|#|#||#|#||#|##|######|#||#|#|#
#||#|#|||/+++-++-+--++---+-+++++++++--+++--+-+++-++-++++-++-+--++-`###||##|##|||||||##||##|#||#|##|##|###||#|#|##||####|#|#||#|#||#|##|######|#||#|#|#
#||#|#|||||||#||#|##||###|#|||||||||#/+++--+-+++-++-++++-++-+--++-+---++--+--+++++++--++--+-++-+--+--+---++-+-+--++----+-+-++-+-++-+`#|######|#||#|#|#
#||#|#|||||||#||#|##||###|#|||||||||#||||##|#|||#||#||||#||#|##||#|###||##|##|||^|||##||##|#||#|##|##|###||#|#|##||####|#|#||#|#||#||#|######|#||#|#|#
#||#|#|||||||#||#|##|`---+-+++++++++-++++--+-+++-++-++++-/|#|##||#|##/++--+--+++++++--++--+-++-+`#|##|###||#|#|##||####|#|#||#|#||#||#|######|#||#|#|#
#||#|#|||||||#|`-+--+----+-++++/||||#||||##|#|||#||#||||##`-+--++-+--+++--+--+++++++--++--+-++-++-+--+---++-+-+--++----+-+-++-+-++-/|#|######|#||#|#|#
#||#|#|||||||#|##|##|###/+-++++-++++-++++--+-+++-++-++++----+--++-+--+++--+--+++++++--++--+-++-++-+--+---++-+-+--++----+-+-++-+-++`#|#|######|#||#|#|#
#||#|#|||||||#|##|##|###||#||||#||||#||||##|#|||#||#||||####|##||#|##|||##|##|||||||##||##|#||#||#|##|###||/+-+--++----+-+-++-+-+++-+-+--`###|#||#|#|#
#||#|#|||||||#|##`--+---++-++++-++++-++++--+-+++-++-++++----+--++-+--+++--+--+++++++--+/##|#||#||#|##|###||||#|##||####|#|/++-+-+++-+-+--+--`|#||#|#|#
#||#|#|||||||#|#####|###||#||||#||||#||||##|#|||#||#||||####`--++-+--+++--+--+++++++--+---+-++-++-+--+---++++-+--++----+-++++-+-+++-+-+--+--++-++-+-/#
#|`-+-+++++++-+-----+---++-++++-/|||#||||##|#|||#||#||||#######||/+--+++--+`#|||||||##|###|#||#||#|##|###||||#|##||####|#||||#|#|||#|#|##|##||#||#|###
#|##|#|||||||#|#####|###||#||`+--+++-++++--+-/|`-++-++++-------++++--+++--++-+++++++--+---+-++-++-+--+---++++-+--++----+-/|||#|#|||#|#|##|##||#||#|###
#|##|#||`++++-+-----+---++-++-+--+++-++++--+--+--++-++++-------++++--+++--++-/||||`+--+---+-++-++-+--+---++++-+--+/####|##|||#|#|||#|#|##|##||#||#|###
#|##|#||#||||#`-----+---++-++-+--+++-++++--+--+--++-++++-------++++--+++--++--++++-+--+---+-++-++-+--+---++++-+--/#####|##|||#|#|||#|#|##|##||#||#|###
#|##|#||#||||#######|###||#||#|##|||#||||/-+--+--++-++++-------++++--+++--++--++++-+--+---+-++-++-+--+---++++-+--------+`#|||#|#|||#|#|##|##||#||#|###
#|##|#||#||||#######|###||#||#|##|||#|||||#|##|##||#||||/------++++--+++--++--++++-+--+--`|#||#||#|##|###||||#|########||#|||#|#|||#|#|##|##||#||#|###
#|##|#||#||||#######|###||#||#|##|||#|||||#|##|##||#|||||######||||##|||##||/-++++-+-<+--++-++-++-+--+---++++-+--------++-+++-+`|||#|#|##|##||#||#|###
#|##|#||#||||#######|###||#||#|##|||#|||||#|/-+--++-+++++------++++--+++--+++-++++-+--+--++-++-++-+--+---++++-+--------++-+++-+++++-+-+`#|##||#||#|###
#|##|#||#||||#######|##/++-++-+--+++-+++++-++-+-`||#|||||######||||##||`--+++-++++-+--+--+/#||#||#|##|###||||#|########||#|||#|||||#|#||#|##||#||#|###
#|##|#||#||||#######|##|||#||#|/-+++-+++++-++-+-+++-+++++------++++--++---+++-++++-+--+--+--++-++-+--+---++++-+-------`||#|||#|||||#|#||#|##||#||#|###
#|##|#||#||||#######|##|||#||#||#|||#|||||#||#|#|||#|||||######||||##||###|||#||||#|##|##|##||#||#|##|###||||#|#######|||#|||#|||||#|#||#|##||#||#|###
#|##|#||#||||#######|##|||#||#||#|||#|||||#||#|#|||#|||||######||||##||###|||#||||#|##|##|##||#||#|##|###||`+-+-------+++-+++-+++++-+-++-/##||#||#|###
#|##|#||#||||#######|##|||#||#||#|||#|||||#||#|#|||#|||||#####/++++--++`##|||#||||#|##|##|##||#||#|##|###||#|#|#######|||#|||#|||||#|#||####||#||#|###
#|##|#||#`+++-------+--+++-++-++-+++-+++++-++-+-+++-+++++-----++++/##|||##|||#||||#|##|##|##||#||#|##|###||#|#|#######|||#|||#|||||#|#||####||#||#|###
#|##|#||##|||#######|##|||#||#||#|`+-+++++-++-+-+++-++/||#####||||###|||##|||#||||#|##|##|##||#||#|##|###||#|#|#######|||#|||#|||||#|#||####||#||#|###
#|##|#||##|||#######|##|||#||#||#|#|#|||`+-++-+-+++-++-++-----++++---+++--+++-++++-+--+--+--++-++-+--+---++-+-/#######|||#|||#|||||#|#||####||#||#|###
#|##|#||##|||#######|##|||#||#||#|#|#||`-+-++-+-++/#||#||#####||||###|||##|||#||||#|##|##|##||#||#|##|###||#|####/----+++-+++-+++++-+-++----++-++`|###
#|##|#||##|||#######|##`++-++-++-+-+-++--+-++-+-/|##||#||#####||||###|||##|||#||||#|##|##|##||#||#|##|###||#|####|####|||#|||#|||||#|#||####||#||||###
#|##|#||##|||#######`---++-++-++-/#|#||##|#||#`--+--++-/|#####||||###|||##||`-++++-+--+--+--++-++-+--+---++-+----+----+++-+++-+/||^#|#||####||#||||###
#|##|#||/-+++----------`||#||#||###|#||##|#||####|##||##|#####||||###|||##||##||||#|##|##|##||#||#|##|###||#|####|####|||#|||#|/+++-+-++----++-++++`##
#|##|#|`+-+++----------+++-++-++---+-++--+-++----+--++--+-----++++---+++--++--++++-+--+--+--/|/++-+--+---++-+----+--`#|||#|||#|||||#|#||####||#|||||##
#|##|#|#|#|||##########|||#||#||###|#||##|#||####|##||##|#####||||###|||##||##||||#|##|##|###||||#|##|###||#|####|##|#|||#|||#|||||#|#||####||#|||||##
#|##|#|#|#|||##########|||#`+-++---+-++--+-++----/##||##|#####||||###|||##||##||||#|##|##|###||||#|##|###||#|####|##|#|||#|||#|||||#|#||####||#|||||##
#|##|#|#|#|||##########|||##|#||###|#||##|#||#######||##|#####||||###|||/-++--++++-+--+--+---++++-+--+`##||#|####|##|#|||#|||#|||||#|#||####||#|||||##
#|##|#|#|#|||##########|||##|#||###|#||##|#||#######||##|#####||||###||||#||##||||#|##|##|###`+++-+--++--++-+----+--+-+++-+++-+++++-+-++----++-+++/|##
#|##|#|#|#|||##########|||##|#||###|#||##|#||#######||##|#####||||###||||#||##||||#|##|##|####|||#|##||##||#|####|##|#|||#|||#|||||#|#||####||#|||#|##
#|##|#|#|#||v##########|||##|#||###|#||##|#||#######||##|#####||||###||||#||##||||#|##|##|####|||#|##||##||#|####|##|#|||#|||#|||||#|#||####||#|||#|##
#|##|#|#|#|||##########|||##|#`+---+-++--+-++-------++--+-----++++---++++-++--++++-+--+--+----+++-+--++--++-+----+--+-+++-+++-/||||#|#||####||#|||#|##
/+--+-+-+-+++---`######|||##|##|###`-++--+-++-------++--+-----++/|###||||#`+--++++-+--/##|####|`+-+--++--++-+----+--+-+++-+/|##||||#|#||####||#|||#|##
||##|#|#|#|||###|######|||##|##|#####||##|#||#####/-++--+-----++-+---++++--+--++++-+-----+----+-+-+--++--++-+----+--+-+++`|#|##||||#|#||####||#|||#|##
|`--+-+-+-+++---+------+++--+--+-----++--+-++-----+-++--+-----++-+---++++--+--++++-+-----+----+-+-+--/|##||#|####|##|#|||||#|##`+++-+-++----++-+++-/##
|###|#|#|#|||###|######|||##|##|#####||##|#||#####|#||##|#####||#|###||||##|##||||#|#####|####`-+-+---+--++-+----+--/#|||||#|###|||#|#||####||#|||####
|###|#|#|#|||###|######|||##|##`-----++--+-++-----+-++--+-----++-+---++++--+--++++-+-----+------+-+---+--++-+----+----/||||#|###|||#|#||####||#|||####
|###|#|#|#|||###|######|`+--+--------++--+-++-----+-++--+-----++-+---++++--+--++++-+-----+---->-+-+---+--++-+----+-----++++-+---++/#|#||####||#|||####
|###|#|#|#||`---+------+-+--/########||##|#||#####|#||##|#####||#|###`+++--+--++++-+-----+------/#|###|##||#|####|#####||||#|###||##|#||####||#|||####
|###|#|#|#||####|######|#|###########||##|#||#####|#||##|#####||#|####`++--+--++++-+-----+--------+---+--+//+----+-----++++-+---++--+-++--`#||#|||####
|###|#|#|#||####|######|#|###########|`--+-++-----+-++--+-----++-+-----++--+--++++-+-----+--------+---+--+-+/####|#####|||`-+---++--+-++--+-/|#|||####
|###|#v#|#||####|######|#|###########`---+-++-----+-++--+-----++-+-----++--+--++++-+-----+--------+---+--+-+-----+-----+++--+---++--/#||##|##|#|||####
|###|#|#`-++----+------/#|###############|#||#####|#||##|#####||#|#####||##|##||||#|#####|########|###|##`-+-----+-----+++--+---++----++--+--+-+/|####
|###|#|###||####|########|###############|#||#####`-++--+-----++<+-----++--+--++++-+-----+--------+---+----+-----+-----++/##|###||####||##|##|#|#|####
|###|#|###||####|########|###############|#||#######||##`-----++-+-----++--+--++++-+-----/########|###|####|#####`-----++---+---++----++--+--+-+-/####
|###|#|###|`----+--------+---------------+-++-------++--------++-+-----++--+--++++-+--------------+---+----+-----------/|###|###||####||##|##|#|######
|###|#|###|#####|##/-----+------`########|#||#######||########||#|#####||##|##|||`-+--------------/###|####|############|###`---++----++--+--/#|######
|###|#`---+-----+--+-----/######|########|#||#######||########||#|#####||##|##|||##|##################|####|############|#######||####||##|####|######
|###|#####|#####|##|############|########|#||#######||########`+-+-----/|##|##|`+--+------------------+----+------------+-------+/####||##|####|######
|###|#####|#####|##|############|########|#||#######||#########|#|######|##|##|#`--+------------------+----+------------+-------+-----/|##|####|######
`---+-----+-----/##|############|########`-++-------++---------+-+------+--+--+----+------------------+----+------------/#######|######|##|####|######
####|#####|########|############|##########|`-------++---------+-+------+--+--+----+------------------+----+--------------------+------/##|####|######
####|#####|########|############|##########|########||#########|#`------+--/##|####`------------------+----+--------------------+---------+----/######
####|#####`--------+------------+----------+--------/|#########|########|#####|#######################|####`--------------------+---------/###########
####`--------------+------------+----------/#########|#########|########`-----+-----------------------/#########################|#####################
###################|############|####################|#########|##############|#################################################|#####################
###################|############|####################`---------+--------------/#################################################|#####################
###################`------------/##############################`----------------------------------------------------------------/#####################
######################################################################################################################################################
"""