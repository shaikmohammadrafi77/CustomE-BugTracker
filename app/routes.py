from flask import Blueprint, render_template, request, redirect, url_for
from .models import BugReport, db

main = Blueprint('main', __name__)

@main.route('/')
def index():
    bugs = BugReport.query.order_by(BugReport.id.desc()).all()
    return render_template('index.html', bugs=bugs)

@main.route('/add', methods=['GET', 'POST'])
def add_bug():
    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        if title and description:
            bug = BugReport(title=title, description=description)
            db.session.add(bug)
            db.session.commit()
            return redirect(url_for('main.index'))
    return render_template('add_bug.html')
