#!/usr/bin/env python 
# -*- coding: utf-8 -*- 

import re
import io
import sqlite3

f = io.open("ewarodai.txt", mode="r", encoding="utf-16")

file_stream = f.read().split("\n")

conn = None
cursor = None
kanji = ""
kana = ""
translate = ""
key = ""
isStarting = True

try:
    conn = sqlite3.connect('jpru.sqlite')
    cursor = conn.cursor()
    cursor.execute('''CREATE TABLE IF NOT EXISTS warodai
                 (id integer primary key autoincrement, kanji text, kana text, trans text, key text)''')
except sqlite3.Error as e:
    print("*** Database error.")


def requestSQL(f_kanji, f_kana, f_translate, f_key):
    print "*** Adding line in DB:"
    print("key: " + f_key)
    print("kanji: " + f_kanji)
    print("kana: " + f_kana)
    print("translate: " + f_translate)

    f_word = (f_kanji, f_kana, f_translate, f_key)

    try:
        cursor.execute("insert into warodai values (NULL, ?, ?, ?, ?);", f_word)
        conn.commit()
        print("*** Successfully added.")
    except Exception as e:
        print("*** Query error.")

print("*** Starting...")

for line in file_stream:
    if line:
        if isStarting:
            c = re.search(ur'〔[A0-9-]+〕', line)
            key = c.group(0)
            key = key[1:-1]

            m = re.search(ur'【.*】', line)

            if m:
                kanji = m.group(0)
                kanji = kanji[1:-1]
            else:
                kanji = ""
                
            n = re.search(ur'.*【', line)

            if n:
                kana = n.group(0)
                kana = kana[0:-1]
                kana = kana.replace(" ", "")
            else:
                n = re.search(ur'.*\(', line)
                kana = n.group(0)
                kana = kana[0:-1]
                kana = kana.replace(" ", "")
                
            isStarting = False
        else:
            translate += line + "<br>"
        
    if not line:  
        dbl = False

        kanji_line = re.search(ur'･', kanji)

        if kanji_line:
            dbl = True

            for j in kanji.split(ur"･"):
                j.strip()
                requestSQL(j, kana, translate, key)
    
        kana_line = re.search(',', kana)

        if kana_line:
            dbl = True
            sKanji = []

            kanji = kanji.replace(ur'･',ur',')

            for g in kanji.split(ur','):
                g.strip()
                sKanji.append(g)
                
            d = 0

            for i in kana.split(ur','):
                i.strip()
                if d > len(sKanji) and d > 0:
                    d = d - 1
                else:
                    sKanji.append(kanji)
                
		requestSQL(sKanji[d], i, translate, key)
                d = d + 1
                
        if not dbl:
            requestSQL(kanji, kana, translate, key)
            
        translate = ""
        dbl = False
        isStarting = True

f.close()

conn.close()

print("*** Finish.")