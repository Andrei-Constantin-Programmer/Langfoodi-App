import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_social_media/repositories/authentication/auth_repo.dart';

void main() {
  group("UpdateUserContract tests", () {
    group("toJson method tests", () {
      test("map returned", () {
        // Arrange
        var contract = UpdateUserContract(
          id: "id1",
          username: "user1",
          email: "mail@example.com",
          password: "pass123",
          profileImageId: "imageId"
        );

        // Act
        var result = contract.toJson();

        // Assert
        expect(result, {
          "id": "id1",
          "username": "user1",
          "email": "mail@example.com",
          "password": "pass123",
          "profileImageId": "imageId"
        });
      });
    });
  });
}