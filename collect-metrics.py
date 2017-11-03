#!/usr/bin/env python
# The MIT License (MIT)
#
# Copyright (c) 2016 Fabio Calefato
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

"""
	 -	https://github.com/collab-uniba/

	Requires:
	-
"""

import getopt
import glob
import logging
import numpy
import os
import re
import string
import sys
from pyexcelerate import Workbook, Style, Font, Fill, Color

__script__ = 'collect-metrics.py'
__author__ = '@bateman'
__license__ = "MIT"
__date__ = '06-06-2016'
__version_info__ = (0, 0, 1)
__version__ = '.'.join(str(i) for i in __version_info__)
__home__ = 'https://github.com/collab-uniba/s'
__download__ = 'https://github.com/collab-uniba/.zip'


class ComputeMetrics(object):
    metric_files = None
    metrics = None
    per_metric_vals = None
    classification_res = None
    models = None
    # metric_names = {'A1': 'AUROC', 'B1': 'F1', 'C1': 'G-mean', 'D1': 'Phi', 'E1': 'Balance', 'F1': 'parameters',
    #                'G1': 'time'}
    metric_names = ['AUROC', 'F1', 'G-mean', 'Phi', 'Balance', 'time', 'parameters']

    descriptive_stats = None
    descriptive_stats_names = ['min', 'max', 'mean', 'median', 'stdev', 'total']

    def __init__(self, infolder, outfile, sep=';', ext='txt', runs=10):
        self.log = logging.getLogger('ComputeMetrics script')

        self.infolder = infolder
        self.outfile = outfile
        self.sep = sep
        self.ext = ext
        self.runs = runs

        self.metric_files = list()
        self.classification_res = dict()
        self.metrics = dict()
        self.descriptive_stats = dict()
        self.models = self.__readmodels('models/models.txt')

    def main(self):
        self.__getfiles()
        for mf in self.metric_files:
            model = mf[:-len(self.ext) - 1]  # strips .ext away
            fcontent = self.__readfile(mf)
            self.classification_res[model] = fcontent

        for model, content in self.classification_res.iteritems():
            self.per_metric_vals = self.__compute_metrics(content)
            self.metrics[model] = self.per_metric_vals

        self.__compute_descriptive_stats()
        self.__save_xls()

    @staticmethod
    def __readmodels(mfile):
        models = list()
        with open(mfile, 'r') as _file:
            content = _file.readlines()

        for m in content:
            models.append(string.split(m.strip(), sep=":")[0])

        return models

    def __getfiles(self):
        os.chdir(self.infolder)
        for f in glob.glob("*.{0:s}".format(self.ext)):
            self.metric_files.append(f)

    @staticmethod
    def __readfile(f):
        with open(f, 'r') as _file:
            _file_content = _file.read()
            return _file_content

    @staticmethod
    def __compute_metrics(content):
        permetric_vals = dict()

        pParams = re.compile("The final values* used for the model (was|were) (.*\n*.*)\.")
        Params_vals = list()
        pTime = re.compile("Time difference of (.* \w+)")
        Time_vals = list()
        pHighROC = re.compile(".*TrainSpec\s+method\n1\s+(\d.\d+)")
        HighROC_vals = list()
        pF1 = re.compile("^F-measure = (.*)$", re.MULTILINE)
        F1_vals = list()
        pGmean = re.compile("^G-mean = (.*)$", re.MULTILINE)
        Gmean_vals = list()
        pPhi = re.compile("^Matthews phi = (.*)$", re.MULTILINE)
        Phi_vals = list()
        pBal = re.compile("^Balance = (.*)$", re.MULTILINE)
        Bal_vals = list()

        for match in re.finditer(pParams, content):
            if match is not None:
                Params_vals.append(match.group(2).replace('\n', ''))
        if len(Params_vals) is 0:
            pParams = re.compile("Tuning parameter \'(.*)\' was held constant at a value of (.*)")
            for match in re.finditer(pParams, content):
                assert (match is not None)
                Params_vals.append(match.group(1) + " = " + match.group(2))
        permetric_vals['parameters'] = Params_vals
        for match in re.finditer(pTime, content):
            assert (match is not None)
            Time_vals.append(match.group(1))
        permetric_vals['time'] = Time_vals
        for match in re.finditer(pHighROC, content):
            assert (match is not None)
            HighROC_vals.append(match.group(1))
        permetric_vals['AUROC'] = HighROC_vals
        for match in re.finditer(pF1, content):
            assert (match is not None)
            F1_vals.append(match.group(1))
        permetric_vals['F1'] = F1_vals
        for match in re.finditer(pGmean, content):
            assert (match is not None)
            Gmean_vals.append(match.group(1))
        permetric_vals['G-mean'] = Gmean_vals
        for match in re.finditer(pPhi, content):
            assert (match is not None)
            Phi_vals.append(match.group(1))
        permetric_vals['Phi'] = Phi_vals
        for match in re.finditer(pBal, content):
            assert (match is not None)
            Bal_vals.append(match.group(1))
        permetric_vals['Balance'] = Bal_vals

        return permetric_vals

    def __compute_descriptive_stats(self):
        for model in self.models:
            descriptive_stats = dict()
            for nmetric in self.metric_names:
                stats = dict()
                if nmetric is not 'parameters':
                    mList = self.metrics[model][nmetric]
                    try:
                        if nmetric is 'time':
                            newList = list()
                            time_unit = ''
                            for elem in mList:
                                i, time_unit = string.split(elem, sep=" ")
                                newList.append(i)
                            mList = numpy.asarray(newList).astype(numpy.float)
                            min = repr(numpy.amin(mList)) + ' ' + time_unit
                            max = repr(numpy.amax(mList)) + ' ' + time_unit
                            mean = repr(numpy.mean(mList)) + ' ' + time_unit
                            median = repr(numpy.median(mList)) + ' ' + time_unit
                            stdev = repr(numpy.std(mList)) + ' ' + time_unit
                            sum = repr(numpy.sum(mList)) + ' ' + time_unit
                            stats['total'] = sum
                        else:
                            mList = numpy.asarray(mList).astype(numpy.float)
                            min = numpy.amin(mList)
                            max = numpy.amax(mList)
                            mean = numpy.mean(mList)
                            median = numpy.median(mList)
                            stdev = numpy.std(mList)
                    except ValueError:
                        min = 'N/A'
                        max = 'N/A'
                        mean = 'N/A'
                        median = 'N/A'
                        stdev = 'N/A'

                    stats['min'] = min
                    stats['max'] = max
                    stats['mean'] = mean
                    stats['median'] = median
                    stats['stdev'] = stdev
                    descriptive_stats[nmetric] = stats
            self.descriptive_stats[model] = descriptive_stats
        pass

    def __save_xls(self):
        wb = Workbook()

        for model in self.models:
            ws = wb.new_sheet(sheet_name=model)

            # sets the column name
            for j in range(1, len(self.metric_names) + 1):
                ws.set_cell_value(1, j + 1, self.metric_names[j - 1])
                # ws.set_cell_style(1, j, Style(fill=Fill(background=Color(224, 224, 224, 224))))
                ws.set_cell_style(1, j + 1, Style(font=Font(bold=True)))

            # sets the cells values
            for i in range(1, self.runs + 1):
                # sets the first value in col 1 to "runX"
                ws.set_cell_value(i + 1, 1, 'run ' + str(i))
                for j in range(1, len(self.metric_names) + 1):
                    try:
                        ws.set_cell_value(i + 1, j + 1, self.metrics[model][self.metric_names[j - 1]][i - 1])
                    except IndexError:
                        ws.set_cell_value(i + 1, j + 1, '')
                    except KeyError:
                        pass

            # after the last run row plus one empty row
            offset = self.runs + 3
            for i in range(0, len(self.descriptive_stats_names)):
                ws.set_cell_value(i + offset, 1, self.descriptive_stats_names[i])
                for j in range(0, len(self.metric_names) - 1):
                    try:
                        ws.set_cell_value(i + offset, j + 2, self.descriptive_stats[model][self.metric_names[j]][
                            self.descriptive_stats_names[i]])
                    except KeyError:
                        pass

        wb.save(self.outfile)


if __name__ == '__main__':
    # default CL arg values
    outfile = 'aggregate-metrics.xlsx'
    sep = ';'
    ext = 'txt'
    runs = 10

    try:
        if (len(sys.argv) <= 1):
            raise (getopt.GetoptError("No arguments!"))
        else:
            opts, args = getopt.getopt(sys.argv[1:], "hi:o:r:e:s:",
                                       ["help", "in=", "out=", "sep="])
    except getopt.GetoptError:
        print('Wrong or no arguments. Please, enter\n\n'
              '\t%s [-h|--help]\n\n'
              'for usage info.' % __script__)
        sys.exit(2)

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print('Usage: {0:s} [OPTIONS]\n'
                  '\t-h, --help                                prints this help\n'
                  '\t-i, --in   <path/to/metrics/folder.txt>   path to metric files\n'
                  '\t-o, --out  <output>.<csv|xls|txt>         output file\n'
                  '\t-r, --runs N                              number of runs\n'
                  '\t-e, --ext  <txt>                          extension of metric files\n'
                  '\t-s, --sep  <,|;>                          either , or ; as separator'.format(__script__))
            sys.exit()
        elif opt in ("-i", "--in"):
            infolder = arg
        elif opt in ("-o", "--out"):
            outfile = arg
        elif opt in ("-r", "--runs"):
            runs = int(arg)
        elif opt in ("-e", "--ext"):
            ext = arg
        elif opt in ("-s", "--sep"):
            sep = arg

    cm = ComputeMetrics(infolder, outfile, sep, ext, runs)
    cm.main()
