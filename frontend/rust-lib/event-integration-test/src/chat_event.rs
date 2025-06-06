use crate::event_builder::EventBuilder;
use crate::EventIntegrationTest;
use flowy_ai::entities::{
  ChatId, ChatMessageListPB, ChatMessageTypePB, LoadNextChatMessagePB, LoadPrevChatMessagePB,
  StreamChatPayloadPB, UpdateChatSettingsPB,
};
use flowy_ai::event_map::AIEvent;
use flowy_folder::entities::{CreateViewPayloadPB, ViewLayoutPB, ViewPB};
use flowy_folder::event_map::FolderEvent;

impl EventIntegrationTest {
  pub async fn create_chat(&self, parent_id: &str) -> ViewPB {
    let payload = CreateViewPayloadPB {
      parent_view_id: parent_id.to_string(),
      name: "chat".to_string(),
      thumbnail: None,
      layout: ViewLayoutPB::Chat,
      initial_data: vec![],
      meta: Default::default(),
      set_as_current: true,
      index: None,
      section: None,
      view_id: None,
      extra: None,
    };
    EventBuilder::new(self.clone())
      .event(FolderEvent::CreateView)
      .payload(payload)
      .async_send()
      .await
      .parse_or_panic::<ViewPB>()
  }

  pub async fn set_chat_rag_ids(&self, chat_id: &str, rag_ids: Vec<String>) {
    let payload = UpdateChatSettingsPB {
      chat_id: ChatId {
        value: chat_id.to_string(),
      },
      rag_ids,
    };
    EventBuilder::new(self.clone())
      .event(AIEvent::UpdateChatSettings)
      .payload(payload)
      .async_send()
      .await;
  }

  pub async fn send_message(
    &self,
    chat_id: &str,
    message: impl ToString,
    message_type: ChatMessageTypePB,
  ) {
    let payload = StreamChatPayloadPB {
      chat_id: chat_id.to_string(),
      message: message.to_string(),
      message_type,
      answer_stream_port: 0,
      question_stream_port: 0,
      format: None,
      prompt_id: None,
    };

    EventBuilder::new(self.clone())
      .event(AIEvent::StreamMessage)
      .payload(payload)
      .async_send()
      .await;
  }

  pub async fn load_prev_message(
    &self,
    chat_id: &str,
    limit: i64,
    before_message_id: Option<i64>,
  ) -> ChatMessageListPB {
    let payload = LoadPrevChatMessagePB {
      chat_id: chat_id.to_string(),
      limit,
      before_message_id,
    };
    EventBuilder::new(self.clone())
      .event(AIEvent::LoadPrevMessage)
      .payload(payload)
      .async_send()
      .await
      .parse_or_panic::<ChatMessageListPB>()
  }

  pub async fn load_next_message(
    &self,
    chat_id: &str,
    limit: i64,
    after_message_id: Option<i64>,
  ) -> ChatMessageListPB {
    let payload = LoadNextChatMessagePB {
      chat_id: chat_id.to_string(),
      limit,
      after_message_id,
    };
    EventBuilder::new(self.clone())
      .event(AIEvent::LoadNextMessage)
      .payload(payload)
      .async_send()
      .await
      .parse_or_panic::<ChatMessageListPB>()
  }

  pub async fn toggle_local_ai(&self) {
    EventBuilder::new(self.clone())
      .event(AIEvent::ToggleLocalAI)
      .async_send()
      .await;
  }
}
