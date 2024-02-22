import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:recipe_social_media/entities/conversation/conversation_entities.dart';
import 'package:recipe_social_media/entities/user/user_entities.dart';
import 'package:recipe_social_media/repositories/authentication/auth_repo.dart';
import 'package:recipe_social_media/repositories/conversation/conversation_repo.dart';
import 'package:equatable/equatable.dart';

export 'conversation_list_bloc.dart';
part 'conversation_list_event.dart';
part 'conversation_list_state.dart';

class ConversationListBloc extends Bloc<ConversationListEvent, ConversationListState> {
  ConversationListBloc(this._conversationRepo, this._authRepo) : super(const ConversationListState()) {
    on<ChangeConversationsToDisplay>(_changeConversationsToDisplay);
    on<SearchConversations>(_searchConversations);
    on<PinConversation>(_pinConversation);
    on<UnpinConversation>(_unpinConversation);
  }

  final AuthenticationRepository _authRepo;
  final ConversationRepository _conversationRepo;

  void _pinConversation(PinConversation event, Emitter<ConversationListState> emit) async {
    _pinOrUnpinConversation(event.conversationId, true);
  }

  void _unpinConversation(UnpinConversation event, Emitter<ConversationListState> emit) async {
    _pinOrUnpinConversation(event.conversationId, false);
  }

  void _pinOrUnpinConversation(String conversationId, bool toPin) async {
    List<String> pinnedIds = List.from(state.pinnedIds);
    if (toPin) {
      pinnedIds.add(conversationId);
    } else {
      pinnedIds.removeWhere((pid) => pid == conversationId);
    }

    User currentUser = await _authRepo.currentUser;
    currentUser.pinnedConversationIds = pinnedIds;
    _authRepo.setCurrentUser(currentUser);

    List<Conversation> sortedConversations = List.from(state.conversations);
    sortedConversations.sort((c1, c2) => pinnedIds
      .indexOf(c2.id)
      .compareTo(pinnedIds
        .indexOf(c1.id)));

    emit(state.copyWith(
      pinnedIds: pinnedIds,
      conversations: sortedConversations
    ));

    if (toPin) {
      await _conversationRepo.pinConversation(conversationId, currentUser.id);
    } else {
      await _conversationRepo.unpinConversation(conversationId, currentUser.id);
    }
  }

  void _searchConversations(SearchConversations event, Emitter<ConversationListState> emit) {
    if (state.conversations.isEmpty) return;
    final searchTerm = event.searchTerm.toLowerCase();

    if (searchTerm == state.prevSearchTerm) {
      return emit(state.copyWith(searchSuggestions: []));
    }

    List<bool> shownConversations = List.from(state.shownConversations);
    List<String> newSuggestions = [];

    for (int i=0; i<shownConversations.length; i++) {
      if (searchTerm.isEmpty) {
        shownConversations[i] = true;
      } else if (!state.conversations[i].name.toLowerCase().contains(searchTerm)) {
        shownConversations[i] = false;
      } else {
        shownConversations[i] = true;
        if (newSuggestions.length < 5) {
          newSuggestions.add(state.conversations[i].name);
        }
      }
    }

    emit(state.copyWith(
      shownConversations: shownConversations,
      searchSuggestions: newSuggestions,
      prevSearchTerm: searchTerm
    ));
  }

  void _changeConversationsToDisplay(ChangeConversationsToDisplay event, Emitter<ConversationListState> emit) async {
    final currentUser = await _authRepo.currentUser;
    List<Conversation> conversations = await _conversationRepo.getConversationByUser(currentUser.id);
    conversations.sort((c1, c2) =>
      currentUser.pinnedConversationIds
        .indexOf(c2.id)
        .compareTo(currentUser.pinnedConversationIds
          .indexOf(c1.id)));

    emit(state.copyWith(
      pinnedIds: currentUser.pinnedConversationIds,
      conversations: conversations,
      shownConversations:
        state.shownConversations.isEmpty
        || state.shownConversations.length != conversations.length
          ? List.generate(conversations.length, (_) => true)
          : state.shownConversations
    ));
  }
}