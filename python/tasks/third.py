import uuid
import datetime
import math


class User:
    def __init__(self, full_name):
        self.full_name = full_name
        self.uuid = uuid.uuid4()
        self.__posts = []
        self.follows = set()
        self.followers = set()

    def add_post(self, post_content):
        post = Post(self, post_content)
        self.__posts.append(post)
        if len(self.__posts) == 51:
            del self.__posts[0]

    def get_post(self):
        return iter(self.__posts)

    def follow(self, user):
        self.follows.add(user)

    def unfollow(self, user):
        self.follows.remove(user)

    def add_follower(self, user):
        self.followers.add(user)

    def remove_follower(self, user):
        self.followers.remove(user)


class Post:
    def __init__(self, user, post_content):
        self.author = user.uuid
        self.published_at = datetime.datetime.now()
        self.content = post_content


class UserAlreadyExistsError(Exception):
    pass


class UserDoesNotExistError(Exception):
    pass


class SocialGraph:
    def __init__(self):
        self.__users = {}

    def __check_user_existence(self, user_uuid):
        if user_uuid not in self.__users.keys():
            raise UserDoesNotExistError

    def add_user(self, user):
        if(user.uuid in self.__users):
            raise UserAlreadyExistsError
        self.__users[user.uuid] = user

    def get_user(self, user_uuid):
        self.__check_user_existence(user_uuid)
        return self.__users[user_uuid]

    def delete_user(self, user_uuid):
        self.__check_user_existence(user_uuid)
        del self.__users[user_uuid]

    def follow(self, follower, followee):
        self.__check_user_existence(follower)
        self.__check_user_existence(followee)
        self.__users[follower].follow(followee)
        self.__users[followee].add_follower(follower)

    def unfollow(self, follower, followee):
        self.__check_user_existence(follower)
        self.__check_user_existence(followee)
        self.__users[follower].unfollow(followee)
        self.__users[followee].remove_follower(follower)

    def is_following(self, follower, followee):
        self.__check_user_existence(follower)
        self.__check_user_existence(followee)
        return follower in self.__users[followee].followers

    def followers(self, user_uuid):
        self.__check_user_existence(user_uuid)
        return self.__users[user_uuid].followers

    def following(self, user_uuid):
        self.__check_user_existence(user_uuid)
        return self.__users[user_uuid].follows

    def friends(self, user_uuid):
        self.__check_user_existence(user_uuid)
        user = self.__users[user_uuid]
        return user.followers.intersection(user.follows)

    def get_next_layer(self, visited, layer):
        layer = {next for uuid in layer for next in self.__users[uuid].follows}
        return layer.difference(visited)

    def max_distance(self, user_uuid):
        self.__check_user_existence(user_uuid)
        visited = set()
        visited.add(user_uuid)
        layer = set()
        layer.add(user_uuid)
        count = -1
        while layer:
            count += 1
            layer = self.get_next_layer(visited, layer)
            visited = visited.union(layer)
        return count

    def min_distance(self, from_user_uuid, to_user_uuid):
        self.__check_user_existence(from_user_uuid)
        self.__check_user_existence(to_user_uuid)
        visited = set()
        visited.add(from_user_uuid)
        layer = set()
        layer.add(from_user_uuid)
        count = 0
        while layer:
            count += 1
            if to_user_uuid in layer:
                return count - 1
            layer = self.get_next_layer(visited, layer)
            visited = visited.union(layer)
        return math.inf

    def nth_layer_followings(self, user_uuid, n):
        self.__check_user_existence(user_uuid)
        visited = set()
        visited.add(user_uuid)
        layer = set()
        layer.add(user_uuid)
        count = 0
        while layer:
            if count == n:
                return layer
            count += 1
            layer = self.get_next_layer(visited, layer)
            visited = visited.union(layer)
        return layer

    def generate_feed(self, user_uuid, offset=0, limit=10):
        self.__check_user_existence(user_uuid)
        follows = self.__users[user_uuid].follows

        def posts_per_user(user_uuid):
            return self.__users[user_uuid].get_post()

        posts = [post for user in follows for post in posts_per_user(user)]
        posts = reversed(sorted(posts, key=lambda post: post.published_at))
        end = offset + limit
        return list(posts)[offset:end]
