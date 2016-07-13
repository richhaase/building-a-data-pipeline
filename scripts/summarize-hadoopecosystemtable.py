''' Summarize the hadoopecosystemtable.github.io '''
import requests

from bs4 import BeautifulSoup

URL = 'https://hadoopecosystemtable.github.io/'
URL_20150713 = 'https://raw.githubusercontent.com/hadoopecosystemtable/hadoopecosystemtable.github.io/e0ae99d951661789c4ca45c93587b9167d436adc/index.html'

def main():
    '''
    Fetch the names and descriptions of all applications on listed on
    hadoopecosystem.github.io by category.
    Then print a simple summary.
    '''
    page = requests.get(URL)
    soup = BeautifulSoup(page.content, 'html.parser')

    table = soup.findAll('table')[0]
    rows = table.findAll('tr')

    swgrps = {}
    for row in rows:
        th = row.find('th')
        if th is not None:
            heading = th.renderContents()
            swgrps[heading] = []

        cols = row.findAll('td')
        if len(cols) > 0:
            title = cols[0].renderContents()
            desc = cols[1].renderContents()
            swgrps[heading].append((title, desc))

    total = 0
    for grp in sorted(swgrps.keys()):
        ct = len(swgrps[grp])
        total += ct
        print '%-25s %4s' % (grp, ct)

    print '%-25s %4s' % ('-' * 25, '-' * 4)
    print '%-25s %4s' % ('Total', total)

if __name__ == '__main__':
    main()
