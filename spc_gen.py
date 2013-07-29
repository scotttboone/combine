#!/bin/python

from collections import defaultdict
import csv
#> SCRIPT FOR GENERATING species_def.conc FILES FOR CMAQ v4.7.1 COMBINE
#> REQUIRES CSV OF AIRPORT INDICES (OUTPUT FROM MONTE CARLO ALLOCATION)
#> AND CSV OF APT/COL/ROW, INDEXED SIMILARLY TO M.C. OUTPUT

#> Choose species Grouping
#SPC = defaultdict(list)
#SPC = {'PRIPM25': ['CO', 'SO2', 'NO', 'NO2', 'HONO', 'ALD2', 'ALDX', 'ETH', 'ETHA', 'ETOH', 'FORM', 'IOLE', 'MEOH', 'OLE', 'TOL', 'XYL', 'AORGPAI', 'AORGPAJ', 'AECI', 'AECJ', 'ASO4I', 'ASO4J']} # all species together
#SPC = {'SO2': ['SO2'], 'NOZ': ['NO', 'NO2', 'HONO'], 'VOC': ['CO', 'ALD2', 'ALDX', 'ETH', 'ETHA', 'ETOH', 'FORM', 'IOLE', 'MEOH', 'OLE', 'TOL', 'XYL'], 'POC': ['AORGPAI', 'AORGPAJ'], 'PEC': ['AECI', 'AECJ'], 'PSO4': ['ASO4I', 'ASO4J']} # 6 superspecies
#SPC = {'CO': ['CO'], 'SO2': ['SO2'], 'NOZ': ['NO', 'NO2', 'HONO'], 'VOC': ['ALD2', 'ALDX', 'ETH', 'ETHA', 'ETOH', 'FORM', 'IOLE', 'MEOH', 'OLE', 'TOL', 'XYL'], 'POC': ['AORGPAI', 'AORGPAJ'], 'PEC': ['AECI', 'AECJ'], 'PSO4': ['ASO4I', 'ASO4J']}# 7 superspecies
#SPC = {'SO2': ['SO2'], 'NOZ': ['NO', 'NO2', 'HONO'], 'VOC': ['ALD2', 'ALDX', 'ETH', 'ETHA', 'ETOH', 'FORM', 'IOLE', 'MEOH', 'OLE', 'TOL', 'XYL'], 'POC': ['AORGPAI', 'AORGPAJ'], 'PEC': ['AECI', 'AECJ'], 'PSO4': ['ASO4I', 'ASO4J']} # 6 superspecies, no CO
SPC = ['SO2','NOZ','VOC','POC','PEC','PSO4'] # 6 superspecies, as list

#> Parameter output species list
AVGSPC = ['A25I','A25J','AECI','AECJ','AISO1J','AISO2J','AISO3J','ANAI','ANAJ','ANH4I','ANH4J','ANO3I','ANO3J','AOLGAJ','AOLGBJ','AORGCJ','AORGPAI','AORGPAJ','ASO4I','ASO4J','ASQTJ','ATOL1J','ATOL2J','ATOL3J','ATRP1J','ATRP2J','AXYL1J','AXYL2J','AXYL3J']


#> Open .csv airport grid where each row is a list of airports, indexed by place in
#> alphabetical order  
with open('aptgrid.csv', 'rb') as aptGridFile:
	aptList = list(csv.reader(aptGridFile))
	for j, aptRow in enumerate(aptList):

		#> Throw away -1 placeholders
		for k in range(1, aptRow.count('-1') + 1):
			aptRow.remove('-1')

		#> Build file
		FILENAME = 'species_def-' + str(j + 1) + '.conc'
		FILE = open(FILENAME, 'wb')
		print "opening file " + str(j + 1) + ", row " + str(j)	
		#> Define lists
		APT = []
		#COL = []
		#ROW = []

		#> Grab row/col info
		with open('99_apts_gridcells_alpha.csv', 'rb') as csvFile:
			csvList = list(csv.reader(csvFile))
			for elem in aptRow:
				APT.append(csvList[int(elem) - 1][0])
				#COL.append(csvList[int(elem) - 1][1])
				#ROW.append(csvList[int(elem) - 1][2])

		print '\nGenerating combine species def file for:\n'
		print '{0:3s}'.format('APT')
		print '-----------'
		for i, A in enumerate(APT):
				print '{0:3s}'.format(A)
		print '\nSPECIES'
		print '-------'
		for S in SPC:
				print S
	
		#> Build file header
		FILE.write('!#start   2005001  010000\n')
		FILE.write('!#end     2005032  000000\n')
		FILE.write('#layer         1\n\n')
		FILE.write('! Species def file for airpots ' + ', '.join(APT) + '\n')
		FILE.write('! and parameter species ' + ', '.join(SPC) + '\n')
		FILE.write('! and output species ' + ', '.join(AVGSPC) + '\n\n')
		#> Build sens modules
		for i, A in enumerate(APT):
			FILE.write('! ' + A + '\n')
			for S in SPC:
				FILE.write(A + '_' + S + ',ug/m3,')

				for  AS in AVGSPC[:-1]:
					FILE.write(AS +'_' + A + '_' + S + '[1]+')
				FILE.write(AVGSPC[-1] + '_' + A + '_' + S + '[1]\n')

			FILE.write('\n')
		FILE.write('! TOTALS\n')
		for i, A in enumerate(APT):
			FILE.write(A + ',ug/m3,')
			for S in SPC[:-1]:
				FILE.write(A + '_' + S + '[0]+')
			FILE.write(A + '_' + SPC[-1] + '[0]\n')
		FILE.write('TOT,ug/m3,')
		for A in APT[:-1]:
			FILE.write(A + '[0]+')
		FILE.write(APT[-1] + '[0]\n')
		FILE.close()
		print '\nFile written.'
	
	
