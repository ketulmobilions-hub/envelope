import 'package:envelope_api_client/src/exceptions.dart';
import 'package:envelope_api_client/src/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// API client for envelope, category group, and allocation operations.
class EnvelopesApiClient {
  /// Creates an [EnvelopesApiClient] with the given [SupabaseClient].
  const EnvelopesApiClient({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  // --- Category Groups ---

  /// Fetches a category group by [id].
  Future<CategoryGroupDto> getCategoryGroup(String id) async {
    try {
      final response = await _supabaseClient
          .from('category_groups')
          .select()
          .eq('id', id)
          .single();
      return CategoryGroupDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all category groups for a budget.
  Future<List<CategoryGroupDto>> getCategoryGroupsByBudget(
    String budgetId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('category_groups')
          .select()
          .eq('budget_id', budgetId)
          .order('sort_order');
      return response.map(CategoryGroupDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new category group.
  Future<CategoryGroupDto> createCategoryGroup(
    CategoryGroupDto categoryGroup,
  ) async {
    try {
      final json = categoryGroup.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('updated_at');
      final response = await _supabaseClient
          .from('category_groups')
          .insert(json)
          .select()
          .single();
      return CategoryGroupDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing category group.
  Future<CategoryGroupDto> updateCategoryGroup(
    CategoryGroupDto categoryGroup,
  ) async {
    try {
      final response = await _supabaseClient
          .from('category_groups')
          .update(categoryGroup.toJson())
          .eq('id', categoryGroup.id)
          .select()
          .single();
      return CategoryGroupDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes a category group by [id].
  Future<void> deleteCategoryGroup(String id) async {
    try {
      await _supabaseClient.from('category_groups').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Envelopes ---

  /// Fetches an envelope by [id].
  Future<EnvelopeDto> getEnvelope(String id) async {
    try {
      final response = await _supabaseClient
          .from('envelopes')
          .select()
          .eq('id', id)
          .single();
      return EnvelopeDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all envelopes for a budget.
  Future<List<EnvelopeDto>> getEnvelopesByBudget(String budgetId) async {
    try {
      final response = await _supabaseClient
          .from('envelopes')
          .select()
          .eq('budget_id', budgetId)
          .order('sort_order');
      return response.map(EnvelopeDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all envelopes for a category group.
  Future<List<EnvelopeDto>> getEnvelopesByCategoryGroup(
    String categoryGroupId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('envelopes')
          .select()
          .eq('category_group_id', categoryGroupId)
          .order('sort_order');
      return response.map(EnvelopeDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new envelope.
  Future<EnvelopeDto> createEnvelope(EnvelopeDto envelope) async {
    try {
      final json = envelope.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('updated_at');
      final response = await _supabaseClient
          .from('envelopes')
          .insert(json)
          .select()
          .single();
      return EnvelopeDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing envelope.
  Future<EnvelopeDto> updateEnvelope(EnvelopeDto envelope) async {
    try {
      final response = await _supabaseClient
          .from('envelopes')
          .update(envelope.toJson())
          .eq('id', envelope.id)
          .select()
          .single();
      return EnvelopeDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes an envelope by [id].
  Future<void> deleteEnvelope(String id) async {
    try {
      await _supabaseClient.from('envelopes').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Envelope Allocations ---

  /// Fetches an envelope allocation by [id].
  Future<EnvelopeAllocationDto> getEnvelopeAllocation(String id) async {
    try {
      final response = await _supabaseClient
          .from('envelope_allocations')
          .select()
          .eq('id', id)
          .single();
      return EnvelopeAllocationDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all allocations for a budget period.
  Future<List<EnvelopeAllocationDto>> getAllocationsByPeriod(
    String budgetPeriodId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('envelope_allocations')
          .select()
          .eq('budget_period_id', budgetPeriodId);
      return response.map(EnvelopeAllocationDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all allocations for an envelope.
  Future<List<EnvelopeAllocationDto>> getAllocationsByEnvelope(
    String envelopeId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('envelope_allocations')
          .select()
          .eq('envelope_id', envelopeId);
      return response.map(EnvelopeAllocationDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new envelope allocation.
  Future<EnvelopeAllocationDto> createEnvelopeAllocation(
    EnvelopeAllocationDto allocation,
  ) async {
    try {
      final json = allocation.toJson()
        ..remove('id')
        ..remove('created_at');
      final response = await _supabaseClient
          .from('envelope_allocations')
          .insert(json)
          .select()
          .single();
      return EnvelopeAllocationDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing envelope allocation.
  Future<EnvelopeAllocationDto> updateEnvelopeAllocation(
    EnvelopeAllocationDto allocation,
  ) async {
    try {
      final response = await _supabaseClient
          .from('envelope_allocations')
          .update(allocation.toJson())
          .eq('id', allocation.id)
          .select()
          .single();
      return EnvelopeAllocationDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes an envelope allocation by [id].
  Future<void> deleteEnvelopeAllocation(String id) async {
    try {
      await _supabaseClient.from('envelope_allocations').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Allocation Templates ---

  /// Fetches an allocation template by [id].
  Future<AllocationTemplateDto> getAllocationTemplate(String id) async {
    try {
      final response = await _supabaseClient
          .from('allocation_templates')
          .select()
          .eq('id', id)
          .single();
      return AllocationTemplateDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Fetches all allocation templates for a budget.
  Future<List<AllocationTemplateDto>> getAllocationTemplatesByBudget(
    String budgetId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('allocation_templates')
          .select()
          .eq('budget_id', budgetId);
      return response.map(AllocationTemplateDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new allocation template.
  ///
  /// Server-generated fields (`id`, `created_at`) are stripped so Supabase
  /// applies its defaults.
  Future<AllocationTemplateDto> createAllocationTemplate(
    AllocationTemplateDto template,
  ) async {
    try {
      final json = template.toJson()
        ..remove('id')
        ..remove('created_at');
      final response = await _supabaseClient
          .from('allocation_templates')
          .insert(json)
          .select()
          .single();
      return AllocationTemplateDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing allocation template.
  Future<AllocationTemplateDto> updateAllocationTemplate(
    AllocationTemplateDto template,
  ) async {
    try {
      final response = await _supabaseClient
          .from('allocation_templates')
          .update(template.toJson())
          .eq('id', template.id)
          .select()
          .single();
      return AllocationTemplateDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes an allocation template by [id].
  Future<void> deleteAllocationTemplate(String id) async {
    try {
      await _supabaseClient.from('allocation_templates').delete().eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  // --- Allocation Template Items ---

  /// Fetches all items for an allocation template.
  Future<List<AllocationTemplateItemDto>> getAllocationTemplateItems(
    String templateId,
  ) async {
    try {
      final response = await _supabaseClient
          .from('allocation_template_items')
          .select()
          .eq('template_id', templateId);
      return response.map(AllocationTemplateItemDto.fromJson).toList();
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Creates a new allocation template item.
  ///
  /// Server-generated field (`id`) is stripped so Supabase applies its default.
  Future<AllocationTemplateItemDto> createAllocationTemplateItem(
    AllocationTemplateItemDto item,
  ) async {
    try {
      final json = item.toJson()..remove('id');
      final response = await _supabaseClient
          .from('allocation_template_items')
          .insert(json)
          .select()
          .single();
      return AllocationTemplateItemDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Updates an existing allocation template item.
  Future<AllocationTemplateItemDto> updateAllocationTemplateItem(
    AllocationTemplateItemDto item,
  ) async {
    try {
      final response = await _supabaseClient
          .from('allocation_template_items')
          .update(item.toJson())
          .eq('id', item.id)
          .select()
          .single();
      return AllocationTemplateItemDto.fromJson(response);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }

  /// Deletes an allocation template item by [id].
  Future<void> deleteAllocationTemplateItem(String id) async {
    try {
      await _supabaseClient
          .from('allocation_template_items')
          .delete()
          .eq('id', id);
    } catch (error) {
      throw EnvelopeApiException.fromPostgrestException(error);
    }
  }
}
