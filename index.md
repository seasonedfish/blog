{% comment %} 
    The following block loops though the posts in _posts/
    to display all of them.
    Source: https://stackoverflow.com/a/43121111
{% endcomment %}
    
<ul>
    {% for post in site.posts %}
    <article>
        <h2>
            <a href="{{ post.url }}">
                {{ post.title }}
            </a>
        </h2>
        <time datetime="{{ post.date | date: '%Y-%m-%d'}}">{{ post.date | date_to_long_string }}</time>
        {{ post.content }}
    </article>
    {% endfor %}
</ul>