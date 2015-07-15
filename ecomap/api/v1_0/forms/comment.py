import wtforms_json
from wtforms_alchemy import ModelForm
from api.v1_0.models import Comment

wtforms_json.init()

class CommentForm(ModelForm):
        class Meta:
            model = Comment
            exclude = ['created_date']