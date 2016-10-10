import web
import boto3

class Index(object):
    def GET(self):
        return render.index("")

    def POST(self):
        form = web.input(search="")
        str = "*" + form.search + "*"
        return render.index(self.get_name(str))

    def get_name(self, tag):
        ec2 = boto3.resource('ec2')
        instances = ec2.instances.filter(Filters=[{'Name': 'tag:Name', 'Values': [tag]}])
        res = []
        for instance in instances:
            for tag in instance.tags:
                if tag['Key'] == 'Name':
                    res.append(tag['Value'])
        return sorted(res)

if __name__ == "__main__":
    urls = (
      '/', 'Index',
      '/(js|css|images)/(.*)', 'static'
    )
    app = web.application(urls, globals())
    render = web.template.render('templates/')
    app.run()
