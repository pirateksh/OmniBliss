# Generated by Django 3.2 on 2021-04-10 20:58

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('profile_app', '0003_alter_profile_gender'),
    ]

    operations = [
        migrations.AddField(
            model_name='profile',
            name='annual_salary',
            field=models.PositiveBigIntegerField(default=None, null=True),
        ),
    ]
