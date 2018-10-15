'''
get the third latest date object out of an array of date objects 
'''
import operator

class Date:
    def __init__(self, day, month, year):
        self.day = day
        self.month = month
        self.year = year


def switch_dates(top_three_dates, date, index):
     length = len(top_three_dates)
     for i in range(length-1,index-1,-1):
         top_three_dates[i] = top_three_dates[i-1]
     top_three_dates[index] = date
     return True


def comapre_days(top_three_dates, date, index):
        if top_three_dates[index].day < date.day:
            return switch_dates(top_three_dates, date, index)
        else:
            #we return true because it's a duplicate so we know we can skip to the next date
            return True


def comapre_months(top_three_dates, date, index):
    if top_three_dates[index].month < date.month:
        return switch_dates(top_three_dates, date, index)
    elif top_three_dates[index].month == date.month:
        return comapre_days(top_three_dates, date, index)
    else:
        return False



def comapre_years(top_three_dates, date):
    did_switch_dates = False
    for i in range(3):
        #stopping in case of an array shift
        if not did_switch_dates:
            if top_three_dates[i].year < date.year:
                return switch_dates(top_three_dates, date, i)
            if top_three_dates[i].year == date.year:
                did_switch_dates = comapre_months(top_three_dates, date, i)
    return False


def third_latest(dates):
    num_of_dates = len(dates)
    top_three_dates = []

    #we have at least 3 dates so we'll initilize the top 3 array with them
    # and order them once
    for i in range(3):
        top_three_dates.append(dates[i])

    top_three_dates = sorted(top_three_dates, key=operator.attrgetter('year','month','day'), reverse=True)
    
    for i in range(3, num_of_dates):
            comapre_years(top_three_dates, dates[i])

    # for date in top_three_dates:
    #     print "{}-{}-{}".format(date.day,date.month,date.year)

    return top_three_dates[-1]




dates = []
dates.append(Date(1,1,2099))
dates.append(Date(1,1,2000))
dates.append(Date(1,2,2008))
dates.append(Date(1,3,2000))
dates.append(Date(1,4,2000))
dates.append(Date(1,1,2099))
dates.append(Date(1,5,2000))
dates.append(Date(1,5,2000))
dates.append(Date(1,5,2001))
dates.append(Date(1,5,2002))
dates.append(Date(1,5,2003))
dates.append(Date(1,5,2004))
dates.append(Date(1,5,2005))
dates.append(Date(1,5,2004))
dates.append(Date(1,5,1999))
dates.append(Date(4,8,2005))
dates.append(Date(1,6,1999))
dates.append(Date(1,6,2005))
dates.append(Date(1,8,2005))
dates.append(Date(1,4,2005))
dates.append(Date(2,5,2005))
dates.append(Date(1,6,2005))
dates.append(Date(1,5,2005))
dates.append(Date(2,8,2005))

date = third_latest(dates)
print "{}-{}-{}".format(date.day,date.month,date.year)