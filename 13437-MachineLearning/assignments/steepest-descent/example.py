#!/bin/env python
# -*- coding: utf-8 -*-

# (c) Sasha Nikiforov GPLv2
# Программа на Python, требуются библиотеки: matplotlib, numpy
# Вариант лабораторной работы №1

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# набросок графика
ylist = np.linspace(-3.0, 3.0)
xlist = np.linspace(-3.0, 3.0)

X, Y = np.meshgrid(xlist, ylist)
Z = 3.5 * X*X - 6*X*Y - Y*Y

fig = plt.figure()
ax = fig.add_subplot(121, projection='3d')
ax.plot_wireframe(X, Y, Z)

cc = fig.add_subplot(122)
cc.contour(X, Y, Z)

# экспортируются библиотеки символьных вычислений
from sympy import Function, hessian, pprint
from sympy.abc import x, y 

# задается функция в символьном виде
z = 3.5 * x*x - 6*x*y - y*y
# выводится значение матрицы Гессе и собственных чисел
# ремарка - полезно собственные числа найти аналитически,
# а потом проверить с помощью ПЭВМ
pprint(hessian(z, (x, y)))
pprint(hessian(z, (x, y)).eigenvals())

# собственные числа -5 and 10, таким образом alpha < 2/10 = 0.2
# значением можно поиграть, чтобы получить представление
# каким образом скорость обучения влияет на скорость сходимости
alpha = 0.01
# 20 итераций поиска
iterations = 20
# Вектор значений - мы хотим вывести на экран траекторию,
# поэтому двумерный массив [итерции, 2]
solution = np.zeros((iterations, 2))
x0 = np.array((1, 1)).reshape(2, 1)
# преобразуем начальное приближение в вектор столбец
solution[0, :] = x0.reshape(1, 2)
print("x0: " + str(solution[0, :]))
# Цикл - смотри формулу 3 (наискорейший спуск), шаги 7 и 8 примера выполения
for i in range(0, iterations):
    # умножаем матрицу Гессе на значение вектора параметров на предыдущем шаге
    # формула 3 и 5 - метод наискорейшего спуска
    g = np.array((7, -6, -6, -2)).reshape(2, 2).dot(x0)
    # формула 3, шаги 7 и 8
    x = x0 - alpha * g

    # обновление значений для следующего шага
    x0 = x
    solution[i, :] = x.reshape(1, 2)
    print("x: " + str(solution[i, :]))

cc.plot(solution[:, 0], solution[:, 1], 'r^')

# вывод графического изображения на экран
plt.grid()
plt.show()
