from selenium import webdriver
from selenium.webdriver.support.ui import Select
import pandas as pd
import numpy as np
import re, string
import time

#MiRNA data input

miR = pd.read_table("G:\\2017-summer_fall_project\\MiRNA\\miRNA_name_unique.txt",header = None)

# Create a new instance of the Firefox driver
#driver = webdriver.Firefox(executable_path='E:/geckodriver')

i = 0
while i < len(miR):
    inputdata = miR[i:i + 10]
    print(inputdata)

    driver = webdriver.Firefox(executable_path='E:/geckodriver')

    # go to the miRWalker home page
    driver.get("http://zmf.umm.uni-heidelberg.de/apps/zmf/mirwalk2/miRretsys-self.html")
    ### Select a species, database and input identifier type
    Specie = Select(driver.find_element_by_css_selector('select[name = "specie"]'))

    Specie.select_by_visible_text('Human')

    Database = Select(driver.find_element_by_css_selector('select[id = "category"]'))

    Database.select_by_visible_text('miRBase')

    Nametype = Select(driver.find_element_by_css_selector('select[id = "subcategory"]'))

    Nametype.select_by_visible_text('MiRNA (hsa-miR-1)')

    ###other programs
    driver.find_element_by_css_selector('input[value = "Microt4"]').click()
    Select(driver.find_element_by_name("g2")).select_by_visible_text("OR")

    driver.find_element_by_css_selector('input[value="mirbridge"]').click()
    Select(driver.find_element_by_name("g4")).select_by_visible_text("OR")

    driver.find_element_by_css_selector('input[value="miRDB"]').click()
    Select(driver.find_element_by_name("g5")).select_by_visible_text("OR")

    driver.find_element_by_css_selector('input[value="miRMap"]').click()
    Select(driver.find_element_by_name("g6")).select_by_visible_text("OR")

    driver.find_element_by_css_selector('input[value="miRNAMap"]').click()
    Select(driver.find_element_by_name("g7")).select_by_visible_text("OR")

    driver.find_element_by_css_selector('input[value="Pictar2"]').click()
    Select(driver.find_element_by_name("g8")).select_by_visible_text("OR")

    driver.find_element_by_css_selector('input[value="PITA"]').click()
    Select(driver.find_element_by_name("g9")).select_by_visible_text("OR")

    driver.find_element_by_css_selector('input[value="RNAhybrid"]').click()
    Select(driver.find_element_by_name("g11")).select_by_visible_text("OR")


    ###inputbox
    Inputbox = driver.find_element_by_css_selector('textarea[name ="mirsy"]')
    s = np.array_str(inputdata.values)
    out = re.sub('[\'\[\]]', '',s)
    Inputbox.send_keys(out)

    ##implement search

    driver.find_element_by_css_selector('input[id="upload"]').click()

    ###select and download table
    #driver.find_element_by_css_selector('a[href = "./mirretsys/t_progs.php"]').click()
    driver.find_element_by_xpath("(//a[contains(text(),'3UTR')])[2]").click()
    time.sleep(5)
    #handles = driver.window_handles

    driver.switch_to.window("20")
    time.sleep(5)
    driver.find_element_by_link_text("Download Complete Table").click()

    #driver.switch_to.alert.accept()
    time.sleep(40)
    i = i + 10
    driver.quit()