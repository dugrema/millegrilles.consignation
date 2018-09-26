#!/usr/bin/python3

import mysql.connector
import json, time
import traceback
from stompy.simple import Client

class ImportDataToTransaction:

  def __init__(self):
    pass

  def connecter(self):
    self._cnx = None
    self._cnx = mysql.connector.connect(user='cuisine_senseur', password='cuisine',
                                        host='mysql',
                                        database='lectmeteo')
  def executer(self):
    self.connecter()


def main():
  importer = ImportDataToTransaction()
  importer.connecter()


main()
